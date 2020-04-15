class ProjectType < ApplicationRecord
  has_many :projects

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
