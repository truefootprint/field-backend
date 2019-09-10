class Problem < ApplicationRecord
  belongs_to :subject, polymorphic: true

  validates :state, inclusion: { in: %w[open resolved] }
end
