class Unit < ApplicationRecord
  TYPES = %w[fraction length mass volume temperature time].freeze

  def self.available_types
    Unitwise::Atom.all.map(&:property).uniq
  end

  self.inheritance_column = :_disabled

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :type, inclusion: { in: TYPES }

  validate :name_is_recognised
  validate :type_matches_property

  def name_is_recognised
    return if errors.present? || unitwise_unit
    errors.add(:name, "must be a recognised unit (lower-case, singular)")
  end

  def type_matches_property
    return if errors.present? || type == unitwise_property
    errors.add(:type, "is #{type} but #{name} is a #{unitwise_property}")
  end

  private

  def unitwise_unit
    @unitwise_unit ||= Unitwise.search(name).first if name.present?
  end

  def unitwise_atom
    unitwise_unit.atoms.first if unitwise_unit
  end

  def unitwise_property
    unitwise_atom.property if unitwise_atom
  end
end
