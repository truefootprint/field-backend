class Unit < ApplicationRecord
  TYPES = %w[length volume weight].freeze

  self.inheritance_column = :_disabled

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :type, inclusion: { in: TYPES }

  validate :name_is_recognised

  def name_is_recognised
    return if Unitwise.search(name).present?
    errors.add(:name, "must be a recognised unit (lower-case, singular)")
  end
end
