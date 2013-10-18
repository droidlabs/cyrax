class Cyrax::Resource < Cyrax::Base
  include Cyrax::Extensions::HasResource
  include Cyrax::Extensions::HasCallbacks
  include Cyrax::Extensions::HasService
  include Cyrax::Extensions::HasDecorator
end
