[< back to README](https://github.com/truefootprint/field-backend#readme)

## API tokens

Almost all API endpoints require authentication. The one exception is
[`/translations`](https://field-backend.truefootprint.com/translations) which
simply provides a list of static translations used in the FieldApp. This isn't
sensitive in any way.

To access an endpoint, the user must send their API token in the basic
authentication header. These tokens are created when the user first logs into
the FieldApp and they are stored in encrypted storage on the device. A user can
have multiple active tokens at once if they use the app on multiple devices or
if they have reinstalled the app.

### Device metadata

Whenever an API token is used, we increment the `times_used` field in the
`api_tokens` table and store additional information alongside it, if available.
This includes:

- device manufacturer and model
- field app version
- android operating system version

This is sent from the FieldApp in the 'Field-App' header and extracted in
ApplicationController. We also send the device's language and time zone which
the backend uses to set `I18n.locale` in order to respond in the correct
language.

### Admin tokens

Admins also require API tokens. At time of writing, these are created manually
in a rails console with the `ApiToken.generate_for!` method.

Admin users can access their endpoints via the [FieldAmin](http://field-admin.truefootprint.com/)
app. This makes API requests on behalf of their API token that the admin must
enter as the 'password' basic auth field when accessing the application. We
decided to keep FieldAdmin as a separate app rather than incorporating something
like ActiveAdmin into the backend for a couple of reasons:

1. The react-admin framework that FieldApp is using has some nice features we wanted to use (e.g. search)
2. The impact on the backend of some additional API endpoint is less than adding ActiveAdmin views
3. We hope to re-use some of the API endpoints when a special-purpose admin system is built

Some of the endpoints in the application are restricted to `:admins_only` while
others can be accessed by all registered users. Some endpoints check that the
entity being updated was actually created by the user before allowing the
update to take place. For example, the `UpdateProcessor::Response` scopes by
`user` as an identifier so that responses can be updated to only by the
originating user.

### Future upgrades

In general, however there isn't an authorization framework in place to stop user
A updating some of user B's content. This is left to the code to decide whether
this is acceptable on a case-by-case basis.

In the future, it might be wise to upgrade from basic authentication to something
like oauth2, depending on need.

### Example request

First, get a valid token from the database

```sh
$ ssh field-backend.truefootprint.com
$ cd field-backend
$ RAILS_ENV=production bundle exec rails runner 'puts ApiToken.last.token'
i6x61BTvXguGUJob2hUU0g==
```

Then use that token in a request to the backend:

```sh
$ curl --user :i6x61BTvXguGUJob2hUU0g== https://field-backend.truefootprint.com/my_data

{"projects":[{"id":4,"programme_id":3,"project_type_id":3,"name":"Install a hand pump...
```

[< back to README](https://github.com/truefootprint/field-backend#readme)
