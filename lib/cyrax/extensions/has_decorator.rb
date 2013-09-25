module Cyrax::Extensions
  module HasDecorator
    extend ActiveSupport::Concern

    included do
      class_attribute :decorator_class_name
    end

    def decorable?
      !self.class.decorator_class_name.nil?
    end

    def decorator_class
      self.class.decorator_class_name.to_s.classify.constantize
    end

    module ClassMethods
      def decorator(name)
        self.decorator_class_name = name ? name.to_s : nil
      end
    end
  end
end
