class Issue < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :user

  validates :description, presence: true
  validates :critical, inclusion: { in: [true, false] }
end
