class Cyrax::Response
  attr_accessor :message, :errors, :assignments, 
    :result, :resource_name, :options

  def initialize(resource_name, result, options)
    @resource_name = resource_name
    @result = result
    @options = options
    @message = nil
    @errors = []
    @assignments = {}
  end

  def with_errors(errors)
    @errors = errors
    self
  end

  def with_message(message)
    @message = message
    self
  end

  def success?
    @errors.nil? || @errors.empty?
  end

  def failure?
    !success?
  end

  def notice
    message if success?
  end

  def error
    message || errors.first if failure?
  end

  def has_error?(error)
    errors && errors.include?(error)
  end

  def as_json(*args)
    if options[:serializer]
      options[:serializer].new(result).serialize
    else
      result.as_json
    end
  end

  def method_missing(method, *args, &block)
    super unless assignments.has_key?(method)
    assignments[method]
  end
end
