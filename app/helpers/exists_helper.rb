module ExistsHelper
  def exists(scope)
    "EXISTS(#{scope.to_sql})"
  end

  def not_exists(scope)
    "NOT #{exists(scope)}"
  end
end
