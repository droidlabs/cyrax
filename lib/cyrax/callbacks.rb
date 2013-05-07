class Cyrax::Callbacks
  attr_accessor :resource

  def initialize(resource)
    @resource = resource
  end

  def before_save;    end
  def before_create;  end
  def before_update;  end
  def before_destroy; end

  def after_save;    end
  def after_create;  end
  def after_update;  end
  def after_destroy; end
end
