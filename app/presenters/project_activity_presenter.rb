class ProjectActivityPresenter < ApplicationPresenter
  def present(record)
    context = Interpolation::Context.new(record)
    name = context.apply(record.name)

    { id: record.id, name: name }
      .merge(present_source_materials(record))
      .merge(present_questions(record, context))
  end

  def modify_scope(scope)
    scope = scope.order(:order)
    scope = scope.visible if options[:visible]

    scope
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
end
