class Unit < ApplicationRecord
  TYPES = %w[length volume weight].freeze

  self.inheritance_column = :_disabled

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :type, inclusion: { in: TYPES }
end
