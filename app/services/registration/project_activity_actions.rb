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
      create_involvement(project_activity)

      follow_up_activities.each do |follow_up|
        project_activity = create_records_from_template(follow_up)
        create_involvement(project_activity)
      end
    end

    private

    def follow_up_activities
      project_activity.activity.follow_up_activities
    end

    def create_involvement(project_activity)
      Involvement.create!(user: viewpoint.user, project_activity: project_activity)
    end

    def create_records_from_template(activity)
      Template.for(activity).create_records(project_activity.project)
    end
  end
end
