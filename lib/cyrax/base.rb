require 'has_active_logger'
class Cyrax::Base
  include HasActiveLogger::Mixin
  include Cyrax::Extensions::HasResponse

  attr_accessor :params, :accessor

  def initialize(options = {})
    @accessor = options[:as]
    @params = options[:params]
  end
end
