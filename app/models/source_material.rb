class SourceMaterial < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :document
end
