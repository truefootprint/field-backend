class Resolution < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  validates :description, presence: true
end
