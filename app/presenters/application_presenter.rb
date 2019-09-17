class ApplicationPresenter
  def self.present(presentable)
    if presentable.is_a?(ActiveRecord::Relation)
      present_scope(presentable)
    elsif presentable.respond_to?(:map)
      present_collection(presentable)
    else
      present_element(presentable)
    end
  end

  def self.present_scope(scope)
    scope = scope.order(order) if order

    present_collection(scope)
  end

  def self.present_collection(collection)
    collection.map { |e| present_element(e) }
  end

  def self.present_element(element)
    new(element).as_json
  end

  def self.order
    nil
  end

  attr_accessor :record

  def initialize(record)
    self.record = record
  end

  def as_json(_options = {})
    present
  end

  def present
    raise NotImplementedError, "Implement me"
  end
end
