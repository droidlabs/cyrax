class Products::UserResource < Cyrax::BaseResource

  def resource_scope
    accessor.products
  end
end
