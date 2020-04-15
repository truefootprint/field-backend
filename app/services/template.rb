module Template
  def self.for(object)
    "Template::#{object.class.name}".constantize.new(object)
  end

  class ProjectType
    attr_accessor :project_type

    def initialize(project_type)
      self.project_type = project_type
    end

    def create_records(programme, project_name)
      project = Project.create!(
        programme: programme,
        project_type: project_type,
        name: project_name,
      )

      default_roles.each do |default|
        ProjectRole.create!(
          project: project,
          role: default.role,
          order: default.order,
        )
      end

      default_activities.each do |default|
        Template.for(default.activity).create_records(project)
      end

      project
    end

    def default_roles
      DefaultRole.where(project_type: project_type).order(:order)
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
        project_question = ProjectQuestion.create!(
          project_activity: project_activity,
          question: default.question,
          order: default.order,
        )

        default_expected_value(project_question).yield_self do |default|
          break unless default

          ExpectedValue.create!(
            project_question: project_question,
            text_translations: default.text_translations,
            value: default.value,
            unit: default.unit,
          )
        end
      end

      project_activity
    end

    def default_activity(project)
      DefaultActivity.find_by(project_type: project.project_type)
    end

    def default_questions
      DefaultQuestion.where(activity: activity).order(:order)
    end

    def default_expected_value(project_question)
      DefaultExpectedValue.for(question: project_question.question, activity: activity)
    end
  end
end
