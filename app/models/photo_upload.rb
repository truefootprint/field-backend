class PhotoUpload < ApplicationRecord
  belongs_to :response

  has_one_attached :photo

  validates :photo, presence: true
end
