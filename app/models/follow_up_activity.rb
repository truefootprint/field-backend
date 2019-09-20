class FollowUpActivity < ApplicationRecord
  belongs_to :activity
  belongs_to :follow_up_activity, class_name: :Activity
end
