class Programme < ApplicationRecord
  translates :name, :description

  has_many :projects

  validates :name, presence: true
  validates :description, presence: true
end
