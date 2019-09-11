class User < ApplicationRecord
  has_many :user_roles

  validates :name, presence: true
end
