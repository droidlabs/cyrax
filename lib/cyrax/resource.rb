class Cyrax::Resource < Cyrax::Base
  include Cyrax::Extensions::HasResource
  include Cyrax::Extensions::HasRepository
  include Cyrax::Extensions::HasService
  include Cyrax::Extensions::HasDecorator
  include Cyrax::Extensions::HasSerializer
end
