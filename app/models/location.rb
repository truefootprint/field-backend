class Location < ApplicationRecord
  belongs_to :subject, polymorphic: true
end
