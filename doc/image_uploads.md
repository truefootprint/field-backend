[< back to README](https://github.com/truefootprint/field-backend#readme)

## Image uploads

The FieldApp supports image uploads of photos taken by the user, or those
selected from their gallery. There is a special PhotoUploadQuestion type that is
explained in more detail [here](./question_types.md).

When a user takes a photo, the FieldApp sends two requests to the backend:

1) A request to send response data, that includes metadata about the image
2) A request to send the actual image data, in binary format

Due to the nature of how FieldApp works, these requests can occur in any order
and there could be a delay between them, which may be several hours if the user
goes offline. Therefore, the backend is designed to cope with this.

Once both requests have been processed by the backend, this results in Response
records being created which contain metadata about the image, such as its
dimensions and an MD5 fingerprint. The response records are associated with
ActiveStorage records that identify the image files stored on disk.

Users can also upload images for IssueNotes which appear in chat dialogues in
the FieldApp.

At the moment, files are stored on disk on the server but we could swap this out
for something else like an S3 bucket.

### How it works

This synchronization process is handled by the
[PhotoAttachments](https://github.com/truefootprint/field-backend/blob/master/app/services/photo_attachments.rb)
service. This is called when either a response record is updated, through the
/my_updates endpoint or when a photo is uploaded through the /my_photos endpoint.

When a response is updated, we call the `.sync_record!` method which checks the
list of image references in the response's value field. If there are images
referenced that don't have a corresponding photo association, it tries to create
one. This only succeeds if an image can be found that has been uploaded ahead of
time, i.e. the /my_photos request happened _before_ the /my_updates request.

When an image is uploaded, we call the `.sync_image!` method which scans all
tables that might reference images (such as `responses`, `issue_notes`). It
then uses a SQL 'like' query to find any rows for the current user that match
the image's MD5 fingerprint. These records are then updated by the
`.sync_record!` method explained previously.

The combination of these two methods ensures that images can be uploaded
**before** or **after** the records that reference them and the system should
keep in sync, i.e. the 'photos' association is kept up to date.

### Data formats

FieldApp sends metadata to the backend in a format that looks like this:

```javascript
[
  {
    "uri":"/data/tuzz/com.truefootprint.field-app/documents/3c7fdb89de39f29765d46221746a0714.jpg",
    "width":1600,
    "height":900,
    "exif": {
      "DateTimeOriginal": "2010:09:30 07:14:49",
      "Orientation": 1,
      "Compression": 6,

      // ...
    }
]
```

The 'exif' object can contain arbitrary keys and values and differs from device
to device. This also depends on which permissions the user has selected. It can
sometimes contain geo-location data about where the image was taken.

This metadata is parsed in the backend by the
[PhotoMetadata](https://github.com/truefootprint/field-backend/blob/master/app/services/photo_metadata.rb)
service. It outputs a simplified format that is stored in the `responses.value`
column:

```json
[
  {
    "uri":"[[[documents]]]/3c7fdb89de39f29765d46221746a0714.jpg",
    "width":1600,
    "height":900
  },
]
```

The rest of the metadata is stored in the `exif_data_sets` table. You can see
that the image path has been replaced with `[[[documents]]]` which is handled by
the [PhotoSanitiser](https://github.com/truefootprint/field-backend/blob/master/app/services/photo_sanitiser.rb)
serivce. This is to serves two purposes:

1) The `response.values` column is not encrypted so we shouldn't store the user's name there
2) The image path needs to work on any user's device, not just the user who took the photo

The second point is important because images can also be uploaded by users when
they record issues. These photos are shared amongst several users in a chat
dialogue and so we need to make sure the path is generic. This generic path is
then specialised to each user's documents path in the FieldApp.

Note that these data structures are arrays. This is because multiple images can
be uploaded for one PhotoUploadQuestion. The filename is an MD5 fingerprint of
the image data which is computed in the FieldApp.


[< back to README](https://github.com/truefootprint/field-backend#readme)
