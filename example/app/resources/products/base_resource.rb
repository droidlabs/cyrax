class Products::BaseResource < Cyrax::Resource
  resource :product
  decorator Products::Decorator
  serializer Products::Serializer

  repository :find_all do
    scope.page(params[:page]).per(5)
  end
end
