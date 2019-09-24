module Interpolation
  PATTERN = '%{(.*?)}'

  def self.args_scope(scope, column)
    scope.select("regexp_matches(#{column}, '#{PATTERN}', 'g')")
      .flat_map(&:regexp_matches).map(&:strip).uniq
  end

  def self.args_string(string)
    string.match(PATTERN).to_a.tap(&:shift).map(&:strip).uniq
  end

  def self.interpolate(string, &block)
    string.gsub(/#{PATTERN}/) { |s| block.call(s[2..-2].strip) }
  end

  class Context
    attr_accessor :project_activity, :involved_users

    def initialize(project_activity)
      self.project_activity = project_activity
      self.involved_users = lookup_involved_users
    end

    def apply(string)
      Interpolation.interpolate(string) do |role_name|
        involved_users.fetch(role_name).name
      end
    end

    private

    def lookup_involved_users
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

    def user_for(role_name)
      involvement_for(Role.find_by!(name: role_name)).user
    end

    def involvement_for(role)
      Involvement.where(project_activity: project_activity).find_by_role!(role)
    end
  end
end
