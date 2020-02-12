class Resolution < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  has_many_attached :photos, dependent: :destroy

  validates :issue, uniqueness: true
  validates :description, presence: true
end
