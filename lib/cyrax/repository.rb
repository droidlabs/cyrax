class Cyrax::Repository
  include HasActiveLogger::Mixin
  attr_accessor :options
  attr_accessor :accessor
  attr_accessor :params
  attr_accessor :resource_class
  attr_accessor :finders

  def initialize(options = {})
    @options = options
    @accessor = options[:as]
    @params = options[:params]
    @resource_class = options[:resource_class]
    @finders = options[:finders] || {}
  end

  def finder(name, *attrs)
    block = finders[name]
    instance_exec(*attrs, &block)
  end

  def finder?(name)
    finders.has_key?(name)
  end

  def finder_or_run(name, *attrs)
    finder?(name) ? finder(name, *attrs) : send("#{name}!", *attrs)
  end

  # Returns the resource class - e.g. Product by default.
  # If you want your repository to scope with something interesting, 
  # you should override this in your repository by defining the method and returning your own scope
  #
  # @example Overriding scope
  #   class Products::Repository < Cyrax::Repository
  #     def scope
  #       accessor.products
  #     end
  #   end
  def scope
    finder_or_run(:scope)
  end
  def scope!
    resource_class
  end

  # Instantiates the resource
  # @param id [int] ID or nil if you want a new object
  # @param attributes [hash] Attributes you want to add to the resource
  # @return [object] The object
  def build(id, attributes = {})
    finder_or_run(:build, id, attributes)
  end
  def build!(id, attributes = {})
    if id.present?
      resource = find(id)
      resource.attributes = attributes
      resource
    else
      scope.new(default_attributes.merge(attributes))
    end
  end

  # Finds and returns a multiple items within the scope from the DB
  # @return [Array] Array of objects
  def find_all
    finder_or_run(:find_all)
  end
  def find_all!
    defined?(ActiveRecord) && scope.is_a?(ActiveRecord::Relation) ? scope.load : scope.all
  end

  # Finds and returns a single item from the DB
  # @param id [int] ID of item
  # @return [object] The object
  def find(id)
    finder_or_run(:find, id)
  end
  def find!(id)
    scope.find(id)
  end

  # Saves a resource
  # @param resource [object] The resource to save
  def save(resource)
    finder_or_run(:save, resource)
  end
  def save!(resource)
    resource.save
  end

  # Removes a resource
  # Calls destroy method on resource
  # @param resource [object] The resource to destroy
  def delete(resource)
    finder_or_run(:delete, resource)
  end
  def delete!(resource)
    resource.destroy
  end

  def default_attributes
    finder_or_run(:default_attributes)
  end
  def default_attributes!
    {}
  end
end