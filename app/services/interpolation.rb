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
    attr_accessor :project_activity, :participants

    def initialize(project_activity)
      self.project_activity = project_activity
      self.participants = lookup_participants
    end

    def apply(string)
      Interpolation.interpolate(string) do |role_name|
        participants.fetch(role_name).name
      end
    end

    private

    def lookup_participants
      role_names.map do |name|
        [name, Participant.find(project_activity, Role.find_by(name: name))]
      end.to_h
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
  end
end
