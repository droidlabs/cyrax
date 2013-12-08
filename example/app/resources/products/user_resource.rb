class Products::UserResource < Products::BaseResource
  accessible_attributes :description, :model, :price_in_cents, :vendor
  repository :scope do
    accessor.products
  end
end
