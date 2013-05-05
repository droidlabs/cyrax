require 'has_active_logger'
class DroidServices::Base
  include HasActiveLogger::Mixin
  include DroidServices::Extensions::HasResponse

  attr_accessor :params, :accessor

  def initialize(options = {})
    @accessor = options[:as]
    @params = options[:params]
  end
end
