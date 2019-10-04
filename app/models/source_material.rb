class SourceMaterial < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :document

  validates :page, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }
end
