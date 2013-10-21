module Cyrax::Presenters
  class DecoratedCollection < Cyrax::Presenters::BaseCollection
    def initialize(collection, options = {})
      super
      unless options[:decorator]
        raise "Decorator is not defined! Please define it with option :decorator"
      end
    end

    def presented_collection
      @decorated_collection ||= super.map {|item| decorate_item(item)}
    end

    def self.decorate(*args)
      new(*args).presented_collection
    end

    private

      def decorate_item(item)
        options[:decorator].new(item)
      end
  end
end
