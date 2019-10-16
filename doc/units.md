For now, we have a simple implementation of units. Here are some things we
discussed that we might want to implement later:

1) allow users to change which unit to answer a question in via a dropdown

2) set the user's unit preferences based on their selection of this dropdown so
   the next time we ask a question in e.g. meters, it shows yards instead

3) set a locale's unit preferences via a hardcoded list so that units more
   common in a particular country can be configured to be used as default

```ruby
class UnitPreference < ApplicationRecord
  belongs_to :user
  belongs_to :unit
  belongs_to :instead_of, class_name: :Unit

  def self.for_locale
    # look at translation file and return instances of UnitPreference without a user
  end
end
```
