class DefaultQuestion < ApplicationRecord
  belongs_to :activity
  belongs_to :question

  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
