class DroidServices::BaseResource < DroidServices::Base
  include DroidServices::Extensions::HasResource
  include DroidServices::Extensions::HasCallbacks
  include DroidServices::Extensions::HasService
  include DroidServices::Extensions::HasDecorator
end
