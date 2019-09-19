class User < ApplicationRecord
  has_many :user_roles
  has_many :responses

  validates :name, presence: true
end
