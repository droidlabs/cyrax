class Cyrax::Presenter
  def present(object, options = {})
    should_decorate = options[:decorate].nil? || options[:decorate]
    if options[:decorator] && should_decorate
      present_with_decoration(object, options)
    else
      present_without_decoration(object, options)
    end
  end

  class << self
    def present(object, options = {})
      self.new.present(object, options)
    end
  end

  private

  def present_with_decoration(object, options)
    if options[:present] == :collection
      Cyrax::Presenters::DecoratedCollection.new(object, options).present
    else
      options[:decorator].decorate(object)
    end
  end

  def present_without_decoration(object, options)
    if options[:present] == :collection
      Cyrax::Presenters::BaseCollection.new(object, options).present
    else
      object
    end
  end
end