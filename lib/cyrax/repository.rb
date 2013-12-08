class Cyrax::Repository
  include HasActiveLogger::Mixin
  attr_accessor :options
  attr_accessor :accessor
  attr_accessor :params
  attr_accessor :resource_class
  attr_accessor :finder_blocks

  def initialize(options = {})
    @options = options
    @accessor = options[:as]
    @params = options[:params]
    @resource_class = options[:resource_class]
    @finder_blocks = options[:finder_blocks] || {}
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
    if block = finder_blocks[:scope]
      instance_exec(&block)
    else
      resource_class
    end
  end

  # Instantiates the resource
  # @param id [int] ID or nil if you want a new object
  # @param attributes [hash] Attributes you want to add to the resource
  # @return [object] The object
  def build(id, attributes = {})
    if block = finder_blocks[:build]
      instance_exec(id, attributes, &block)
    else
      if id.present?
        resource = find(id)
        resource.attributes = attributes
        resource
      else
        scope.new(default_attributes.merge(attributes))
      end
    end
  end

  # Finds and returns a multiple items within the scope from the DB
  # @return [Array] Array of objects
  def find_all
    if block = finder_blocks[:find_all]
      instance_exec(&block)
    else
      scope.is_a?(ActiveRecord::Relation) ? scope.load : scope.all
    end
  end

  # Finds and returns a single item from the DB
  # @param id [int] ID of item
  # @return [object] The object
  def find(id)
    if block = finder_blocks[:find]
      instance_exec(id, &block)
    else
      scope.find(id)
    end
  end

  # Saves a resource
  # @param resource [object] The resource to save
  def save(resource)
    if block = finder_blocks[:save]
      instance_exec(resource, &block)
    else
      resource.save
    end
  end

  # Removes a resource
  # Calls destroy method on resource
  # @param resource [object] The resource to destroy
  def delete(resource)
    if block = finder_blocks[:delete]
      instance_exec(resource, &block)
    else
      resource.destroy
    end
  end

  def default_attributes
    if block = finder_blocks[:default_attributes]
      instance_exec(&block)
    else
      {}
    end
  end
end