module Cyrax::Extensions
  module HasSerializer
    extend ActiveSupport::Concern

    included do
      class_attribute :_serializer_class
    end

    def serializable?
      !serializer_class.nil?
    end

    def serializer_class
      options[:serializer] || self.class._serializer_class
    end

    module ClassMethods
      def serializer(klass)
        if klass.is_a?(String)
          ActiveSupport::Deprecation.warn "sending String in #serializer method is deprecated. send Class instead"
          klass = klass.constantize
        end
        self._serializer_class = klass
      end
    end
  end
end
