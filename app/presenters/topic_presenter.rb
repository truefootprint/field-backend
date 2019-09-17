class TopicPresenter < ApplicationPresenter
  def present
    { name: record.name }
  end
end
