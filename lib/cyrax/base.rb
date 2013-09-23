require 'has_active_logger'
class Cyrax::Base
  include HasActiveLogger::Mixin
  include Cyrax::Extensions::HasResponse

  attr_accessor :params, :accessor

  def initialize(options = {})
    @accessor = options[:as]
    @params = options[:params]
  end

  def has_extension?(name)
    self.class.has_extension?(name)
  end

  class << self
    def register_extension(name)
      @_extensions ||= []
      @_extensions << name.to_sym
    end

    def has_extension?(name)
      @_extensions ||= []
      @_extensions.include?(name.to_sym)
    end
  end
end
