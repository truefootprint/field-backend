module Interpolation
  PATTERN = '%{(.*?)}'

  def self.args_scope(scope, column)
    scope.select("regexp_matches(#{column}::text, '#{PATTERN}', 'g')")
      .flat_map(&:regexp_matches).map(&:strip).uniq
  end

  def self.args_string(string)
    string.match(PATTERN).to_a.tap(&:shift).map(&:strip).uniq
  end

  def self.interpolate(string, &block)
    string.gsub(/#{PATTERN}/) { |s| block.call(s[2..-2].strip) }
  end

  class ProjectActivityContext
    attr_accessor :project_activity, :registered_users

    def initialize(project_activity)
      self.project_activity = project_activity
      self.registered_users = lookup_registered_users
    end

    def apply(string)
      Interpolation.interpolate(string) do |role_name|
        registered_users.fetch(role_name).name
      end.strip
    end

    private

    def lookup_registered_users
      role_names.map { |n| [n, user_for(n)] }.to_h
    end

    def role_names
      names  = Interpolation.args_string(project_activity.name)
      names += Interpolation.args_scope(project_questions, :text)
      names += Interpolation.args_scope(project_questions.topics, :name)

      names.uniq
    end

    def project_questions
      project_activity.project_questions.joins(:question)
    end

    def project_roles
      project_activity.project.project_roles
    end

    def registrations
      Registration.where(project_activity: project_activity)
    end

    def user_for(role_name)
      role = Role.find_by!(name: role_name)
      project_role = project_roles.find_by!(role: role)
      registration = registrations.find_by!(project_role: project_role)

      registration.user
    end
  end

  class ExpectedValueContext
    attr_accessor :expected_value

    def initialize(expected_value)
      self.expected_value = expected_value
    end

    # TODO: maybe this should get the data type from the question and use the
    # DataTypeParser. We could then do fancier things like:
    #
    # %{true: "It should have been...", false: "It should not have been..." }
    #
    # i.e. some way to swap out the text for true/false cases or other values?

    def apply(string)
      Interpolation.interpolate(string) do |arg|
        next value if arg == "value" || arg == "values" || arg == "n"
        next units if arg == "units" || arg == "unit"
      end.strip
    end

    def units
      return "" unless unit
      singular? ? unit.singular : unit.plural
    end

    def singular?
      value.to_f == 1
    end

    def unit
      expected_value.unit
    end

    def value
      expected_value.value
    end
  end
end
