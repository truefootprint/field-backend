class Visibility < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :visible_to, polymorphic: true
end
