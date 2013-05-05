class DroidServices::Base
  include DroidServices::Extensions::HasLogger
  include DroidServices::Extensions::HasResponse

  attr_accessor :params, :accessor

  def initialize(options = {})
    @accessor = options[:as]
    @params = options[:params]
  end
end
