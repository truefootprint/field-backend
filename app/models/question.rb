class Question < ApplicationRecord
  belongs_to :topic

  validates :text, presence: true, uniqueness: { scope: :topic_id }

  def scoped_to_roles
    Role.where(id: scoped_to_role_ids)
  end

  def scoped_to_roles=(roles)
    unless roles.all?(&:persisted?)
      raise ActiveRecord::AttributeAssignmentError, "Roles must be persisted"
    end

    self.scoped_to_role_ids = roles.map(&:id)
  end
end
