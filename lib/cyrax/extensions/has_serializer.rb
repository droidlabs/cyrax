module Cyrax::Extensions
  module HasSerializer
    extend ActiveSupport::Concern

    included do
      class_attribute :serializer_class_name
    end

    def seializable?
      !self.class.serializer_class_name.nil?
    end

    def serializer_class
      self.class.serializer_class_name.to_s.classify.constantize
    end

    module ClassMethods
      def serializer(name)
        self.serializer_class_name = name ? name.to_s : nil
      end
    end
  end
end
