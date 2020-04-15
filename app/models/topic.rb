class Topic < ApplicationRecord
  translates :name

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
