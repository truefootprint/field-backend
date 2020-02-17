class VersionedContent < ApplicationRecord
  has_ancestry

  belongs_to :subject, polymorphic: true
  belongs_to :user

  validates :content, presence: true

  after_initialize do
    self.photos = "[]" if photos.blank?
  end
end
