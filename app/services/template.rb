module Template
  def self.for(object)
    "Template::#{object.class.name}".constantize.new(object)
  end

  class ProjectType
    attr_accessor :project_type

    def initialize(project_type)
      self.project_type = project_type
    end

    def create_records(project_name)
      project = Project.create!(project_type: project_type, name: project_name)

      default_activities.each do |default|
        Template.for(default.activity).create_records(project)
      end

      project
    end

    def default_activities
      DefaultActivity.where(project_type: project_type).order(:order)
    end
  end

  class Activity
    attr_accessor :activity

    def initialize(activity)
      self.activity = activity
    end

    def create_records(project)
      project_activity = ProjectActivity.create!(
        project: project,
        activity: activity,
        order: default_activity(project)&.order || 1,
      )

      default_questions.each do |default|
        ProjectQuestion.create!(
          project_activity: project_activity,
          question: default.question,
          order: default.order,
        )
      end

      project_activity
    end

    def default_activity(project)
      DefaultActivity.find_by(project_type: project.project_type)
    end

    def default_questions
      DefaultQuestion.where(activity: activity).order(:order)
    end
  end
end
