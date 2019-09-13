class TopicPresenter
  def self.present(scope)
    scope.map { |t| new(t).as_json }
  end

  attr_accessor :topic

  def initialize(topic)
    self.topic = topic
  end

  def as_json(_options = {})
    {
      name: topic.name,
    }
  end
end
