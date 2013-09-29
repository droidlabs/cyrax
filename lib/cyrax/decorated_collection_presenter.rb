class Cyrax::DecoratedCollectionPresenter < Cyrax::BaseCollectionPresenter
  attr_reader :decorator_class

  def initialize(collection, options = {})
    super
    @decorator_class = options[:decorator_class]
    raise "Decorator class is not defined! Please define it with option :decorator_class" unless decorator_class
  end

  class << self
    alias_method :decorate, :new
  end

  array_methods = Array.instance_methods - Object.instance_methods
  delegate *array_methods, to: :decorated_collection

  def decorated_collection
    @decorated_collection ||= fetched_collection.map {|item| decorate_item(item)}
  end

  def method_missing(method, *args, &block)
    return super unless collection.respond_to?(method)
    collection.send(method, *args, &block)
  end

  private

  def decorate_item(item)
    decorator_class.new(item)
  end
end