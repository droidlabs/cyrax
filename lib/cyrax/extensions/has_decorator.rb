module Cyrax::Extensions
  module HasDecorator
    extend ActiveSupport::Concern

    included do
      class_attribute :_decorator_class
    end

    def decorable?
      !decorator_class.nil?
    end

    def decorator_class
      options[:decorator] || self.class._decorator_class
    end

    module ClassMethods
      def decorator(klass)
        if klass.is_a?(String)
          ActiveSupport::Deprecation.warn "sending String in #decorator method is deprecated. send Class instead"
          klass = klass.constantize
        end
        self._decorator_class = klass
      end
    end
  end
end
