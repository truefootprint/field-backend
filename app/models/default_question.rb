class DefaultQuestion < ApplicationRecord
  belongs_to :activity
  belongs_to :question

  validates :order, presence: true
end
