class ResponseTrigger < ApplicationRecord
  belongs_to :question

  validates :value, presence: true
  validates :event_name, presence: true
end
