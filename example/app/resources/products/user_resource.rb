class Products::UserResource < Products::BaseResource
  accessible_attributes :description, :model, :price_in_cents, :vendor
  
  def resource_scope
    accessor.products
  end
end
