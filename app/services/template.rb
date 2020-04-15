module Template
  def self.for(object)
    name = object.class.name
    name = "Question" if name.include?("Question")

    "Template::#{name}".constantize.new(object)
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

      default_roles.map do |default|
        ProjectRole.create!(
          project: project,
          role: default.role,
          order: default.order,
        )
      end

      default_visibilities.each do |default|
        project_role = project.project_roles.detect { |r| r.role == default.role }
        Visibility.create!(subject: project, visible_to: project_role)
      end

      default_activities.each do |default|
        Template.for(default.activity).create_records(project)
      end

      project
    end

    def default_roles
      DefaultRole.where(project_type: project_type).order(:order)
    end

    def default_visibilities
      DefaultVisibility.where(subject: project_type)
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

      default_visibilities.each do |default|
        project_role = project.project_roles.detect { |r| r.role == default.role }
        Visibility.create!(subject: project_activity, visible_to: project_role)
      end

      default_questions.each do |default|
        Template.for(default.question).create_records(project_activity)
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

    def default_visibilities
      DefaultVisibility.where(subject: activity)
    end
  end

  class Question
    attr_accessor :question

    def initialize(question)
      self.question = question
    end

    def create_records(project_activity)
      project_question = ProjectQuestion.create!(
        project_activity: project_activity,
        question: question,
        order: 999,
      )

      default_visibilities.each do |default|
        project_roles = project_question.project.project_roles
        project_role = project_roles.detect { |r| r.role == default.role }

        Visibility.create!(subject: project_question, visible_to: project_role)
      end

      default_expected_value(project_question).yield_self do |default|
        break unless default

        ExpectedValue.create!(
          project_question: project_question,
          text_translations: default.text_translations,
          value: default.value,
          unit: default.unit,
        )
      end

      project_question
    end

    def default_visibilities
      DefaultVisibility.where(subject: question)
    end

    def default_expected_value(project_question)
      activity = project_question.project_activity.activity
      DefaultExpectedValue.for(question: question, activity: activity)
    end
  end
end
