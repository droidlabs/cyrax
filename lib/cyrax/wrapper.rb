class Cyrax::Wrapper
  include HasActiveLogger::Mixin
  attr_accessor :resource
  attr_accessor :options
  attr_accessor :accessor

  def initialize(resource = nil, options = {})
    @resource = resource
    @options = options
    @accessor = options[:as]
  end
end