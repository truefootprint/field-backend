class Involvement < ApplicationRecord
  belongs_to :project_activity
  belongs_to :user
end
