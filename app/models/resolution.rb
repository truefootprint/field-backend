class Resolution < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  has_many :versioned_contents, as: :subject, inverse_of: :subject

  validates :issue, uniqueness: true
  validates :versioned_contents, presence: true

  cattr_accessor :factory_bot
end
