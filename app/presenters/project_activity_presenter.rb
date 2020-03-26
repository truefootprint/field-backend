class ProjectActivityPresenter < ApplicationPresenter
  def present(record)
    context = Interpolation::ProjectActivityContext.new(record)

    super
      .merge(present_name(record, context))
      .merge(present_source_materials(record))
      .merge(present_questions(record, context))
      .merge(present_issues(record))
  end

  def modify_scope(scope)
    scope = scope.order(:order)
    scope = scope.visible if options[:visible]

    scope
  end

  def present_name(record, context)
    if options[:interpolate]
      { name: context.apply(record.name) }
    else
      { name: record.name }
    end
  end

  def present_source_materials(record)
    present_nested(:source_materials, SourceMaterialPresenter) do
      record.source_materials
    end
  end

  def present_questions(record, context)
    present_nested(:project_questions, ProjectQuestionPresenter) do |options|
      options.merge!(interpolation_context: context)

      record.project_questions
    end
  end

  def present_issues(record)
    present_nested(:issues, IssuePresenter) { record.issues }
  end
end
