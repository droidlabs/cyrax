require 'active_model'
class Cyrax::Decorator
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml

  attr_accessor :resource

  def initialize(resource)
    @resource = resource
  end

  def to_model
    resource
  end

  def to_param
    resource.to_param
  end

  def to_partial_path
    resource.to_partial_path
  end

  def method_missing(method, *args, &block)
    return super unless resource.respond_to?(method)

    resource.send(method, *args, &block)
  end

  class << self
    def fetch(resource)
      if resource.is_a?(ActiveRecord::Relation)
        resource.to_a
      elsif resource.respond_to?(:all)
        resource.all
      else
        resource
      end
    end

    def decorate(resource)
      resource = fetch(resource)
      if resource.is_a?(Array)
        resource.map do |item|
          self.new(item)
        end
      else
        self.new(resource)
      end
    end
  end
end
