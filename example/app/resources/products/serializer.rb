class Products::Serializer < Cyrax::Serializer
  default_attributes
  attribute :price do |resource|
    resource.price_in_cents / 100.to_f
  end
  has_one :user do
    attributes :id, :email, :name, :created_at
  end
end
