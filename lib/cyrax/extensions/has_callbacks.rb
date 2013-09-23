require 'active_support/core_ext/object'
require 'active_support/core_ext/class'

module Cyrax::Extensions
  module HasCallbacks
    extend ActiveSupport::Concern

    included do
      register_extension :has_callbacks
      class_attribute :resource_callbacks_handler_class
    end

    def invoke_callback(name, resource)
      if resource_callbacks_handler_class
        resource_callbacks_handler_class.new(resource).send(name)
      end
    end

    module ClassMethods
      def callbacks_handler(name, options = {})
        self.resource_callbacks_handler_class = name
      end
    end
  end
end
