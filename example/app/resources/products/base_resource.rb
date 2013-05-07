class Products::BaseResource < Cyrax::BaseResource
  resource :product, class_name: 'Product'
  decorator 'Products::Decorator'
end
