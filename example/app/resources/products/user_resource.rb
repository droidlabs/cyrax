class Products::UserResource < Products::BaseResource
  def resource_scope
    accessor.products
  end
end
