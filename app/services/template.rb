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
      project = Project.i18n.find_or_create_by!(name: project_name, programme: programme) do |project|
        project.programme = programme
        project.project_type = project_type
        project.name = project_name
      end

      default_roles.map do |default|
        ProjectRole.create!(
          project: project,
          role: default.role,
          order: default.order,
        )
      end

      default_visibilities.each do |default|
        project_role = project.project_roles.detect { |r| r.role == default.role }
        Visibility.create!(subject: project, visible_to: project_role) if !project_role.blank?
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
        Visibility.create!(subject: project_activity, visible_to: project_role) if !project_role.blank?
      end

      default_questions.each do |default_question|
        Template.for(default_question).create_records(project_activity)
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
    attr_accessor :default_question

    def initialize(default_question)
      self.default_question = default_question
    end

    def create_records(project_activity)
      project_question = ProjectQuestion.create!(
        project_activity: project_activity,
        question: default_question.question, # WE are getting the question from the default question
        order: default_question.order, # we get the order from the default question
      )

      default_visibilities.each do |default|
        project_roles = project_question.project.project_roles
        project_role = project_roles.detect { |r| r.role == default.role }

        Visibility.create!(subject: project_question, visible_to: project_role) if !project_role.blank?
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
      DefaultVisibility.where(subject: default_question.question)
    end

    def default_expected_value(project_question)
      activity = project_question.project_activity.activity
      DefaultExpectedValue.for(question: default_question.question, activity: activity)
    end
  end
end
