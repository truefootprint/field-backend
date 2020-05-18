[< back to README](https://github.com/truefootprint/field-backend#readme)

## Translations

The backend uses the [mobility gem](https://github.com/shioyama/mobility) for
translations. This is a modular framework that is configured in
[`config/initializers/mobility.rb`](https://github.com/truefootprint/field-backend/blob/master/config/initializers/mobility.rb).
Rather than have separate tables or columns for translations, we simply store
them in the same column as a JSONB type. An
example translation might look like:

```json
{
  "en": "School construction in the Bilobilo village",
  "fr": "Construction d'une école dans le village de Bilobilo"
}
```

The gem abstracts this storage detail away and retrieves the translation that
match the current `I18n.locale`. This is set in `ApplicationController` which
respects the 'Accept-Language' header passed from the FieldApp. That means
client requests to the backend are always responded in a language that matches
the language setting on the user's device.

Similarly, the gem makes it so that operations like the following only update
the translation for current `I18n.locale`.

```ruby
Project.update!(name: "Project name")
```

### Mass assignment

Some of the `db/seeds/` files use a pattern like this:

```ruby
Topic.create!(
  name_translations: {
    en: "Health center",
    fr: "Centre de santé",
  },
)
```

By default, mobility doesn't support 'mass assigning' all translations in one
go in this way. Therefore, this functionality is added in a custom plugin
located at [`app/helpers/mobility/plugins/mass_assign.rb`](https://github.com/truefootprint/field-backend/blob/master/app/helpers/mobility/plugins/mass_assign.rb).

### Fallbacks

We're using
[Rails' default I18n fallbacks](https://guides.rubyonrails.org/v6.0.0/configuring.html#configuring-i18n)
behaviour. If the locale is set to `fr-CA` and there are no explicit
translations for that, it falls back to `fr` and if there are no translations
for that, it falls back to `en` (English).

### Future work

Eventually, we might want the user to override this language choice by
presenting them with a list of locales that exceeds those supported by default
on Android. For example, if we work in small communities in Africa, they may
use dialects that aren't included by default in Android.

We might also want some alerting when a locale is used that falls back to
another so we can see if we're missing translations. For example, if a user
requests `/my_data` in French but that falls back to English, we would like to
know this so we can ask someone to translate the relevant content into French.

Finally, we might eventually want to plug in a third-party translations
provider such as [Webtranslateit](https://webtranslateit.com) or store
translations in a separate micro service. Hopefully, but using Mobility this is
easy to do since it's modular design makes it flexible and extensible.


[< back to README](https://github.com/truefootprint/field-backend#readme)
