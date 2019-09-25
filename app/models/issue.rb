class Issue < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :user
  has_one :resolution

  has_many_attached :photos

  validates :description, presence: true
  validates :critical, inclusion: { in: [true, false] }
end
