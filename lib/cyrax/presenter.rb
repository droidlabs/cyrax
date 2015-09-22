class Cyrax::Presenter < Cyrax::Wrapper
  def present
    should_decorate = options[:decorate].nil? || options[:decorate]
    if options[:decorator] && should_decorate
      present_with_decoration(resource, options)
    else
      present_without_decoration(resource, options)
    end
  end

  class << self
    def present(resource, options = {})
      self.new(resource, options).present
    end
  end

  private

  def present_with_decoration(resource, options)
    if options[:present] == :collection
      Cyrax::Presenters::DecoratedCollection.new(resource, options)
    else
      options[:decorator].decorate(resource, options)
    end
  end

  def present_without_decoration(resource, options)
    if options[:present] == :collection
      Cyrax::Presenters::BaseCollection.new(resource, options)
    else
      resource
    end
  end
end