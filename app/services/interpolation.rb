module Interpolation
  PATTERN = '%{(.*?)}'

  def self.args_scope(scope, column)
    scope.select("regexp_matches(#{column}, '#{PATTERN}', 'g')")
      .flat_map(&:regexp_matches).map(&:strip).uniq
  end

  def self.args_string(string)
    string.match(PATTERN)[1..].map(&:strip).uniq
  end
end
