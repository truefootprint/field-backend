[< back to README](https://github.com/truefootprint/field-backend#readme)

## Encryption

Personally identifiable data is encrypted in the database. We are using the
[attr_encrypted gem](https://github.com/attr-encrypted/attr_encrypted) for this
which abstracts over the encrypted columns so they can be called in the usual
way, for example:

```ruby
ApiToken.last.token
<returns the unencrypted token>
```

### Blind indexes

One downside of encryption is that it's more difficult to query for records
matching a given value. You'd effectively have to decrypt every row in the table
to check for a match which turns O(1) operations into O(N) operations, which in
most cases is too slow.

Therefore, we use a technique called 'blind indexing' which lets us query
encrypted data without having to decrypt it first. We're using the
[blind_index gem](https://github.com/ankane/blind_index) for this.

### Encryption keys

There are two encryption keys, one for `attr_encrypted` and one for
`blind_index`. These are set through the `KEY` and `BLIND_INDEX_MASTER_KEY`
environment variables, respectively.

In development, you can set these to whatever you like but in production they
must persist between deployments, otherwise you won't be able to decrypt the
existing data. These environment variables are set by an initializer that is
set up by the [infrastructure](https://github.com/truefootprint/infrastructure)
project.

Rather explain precisely how this works, please speak to Chris for more details
since database encryption keys are of a sensitive nature and I don't want this
documentation to leak important information.

### Adding an encrypted field

To add an encrypted field, use the
[EncryptedField helper](https://github.com/truefootprint/field-backend/blob/master/app/helpers/encrypted_field.rb)
in your database migration. Every encrypted field actually requires the
database columns since there's one for the content, one for an initialisation
vector and and another for the blind index.

The helper uses a naming convention to keep encrypted column names consistent
and it sets up the necessary indexes for you with uniqueness constraints as
appropriate.

### Key rotation

We don't currently rotate keys since but we probably should once we have
customers providing personally identifiable data.


[< back to README](https://github.com/truefootprint/field-backend#readme)
