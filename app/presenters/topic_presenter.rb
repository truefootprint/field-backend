class TopicPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, name: interpolate(record.name) }
  end

  private

  def interpolate(string)
    context ? context.apply(string) : string
  end

  def context
    options[:interpolation_context]
  end
end
