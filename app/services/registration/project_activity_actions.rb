class Registration
  class ProjectActivityActions
    def self.run(*args)
      new(*args).run
    end

    attr_accessor :project_activity, :viewpoint

    def initialize(project_activity, viewpoint)
      self.project_activity = project_activity
      self.viewpoint = viewpoint
    end

    def run
      create_follow_up_project_activities
    end

    private

    def create_follow_up_project_activities
      follow_up_activities.each do |follow_up|
        default_order = order_specified_by_project_type(follow_up)

        project_activity = ProjectActivity.create!(
          project: project,
          activity: follow_up,
          order: default_order,
        )

        make_visible(project_activity)

        follow_up.default_questions.each do |default|
          ProjectQuestion.create!(
            subject: project_activity,
            question: default.question,
            order: default.order,
          )
        end
      end
    end

    def order_specified_by_project_type(follow_up)
      DefaultActivity.find_by(project_type: project_type, activity: follow_up)&.order || 1
    end

    def make_visible(subject)
      Visibility.create!(subject: subject, visible_to: user_role || user)
    end

    def follow_up_activities
      activity.follow_up_activities
    end

    def project
      project_activity.project
    end

    def activity
      project_activity.activity
    end

    def project_type
      project.project_type
    end

    def user_role
      UserRole.find_or_create_by!(user: user, role: role) if role
    end

    def user
      viewpoint.user
    end

    def role
      viewpoint.role
    end
  end
end
