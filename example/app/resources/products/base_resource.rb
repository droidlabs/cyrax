class Products::BaseResource < Cyrax::Resource
  resource :product
  decorator Products::Decorator
  serializer Products::Serializer
end
