class Products::BaseResource < Cyrax::Resource
  resource :product
  decorator Products::Decorator
end
