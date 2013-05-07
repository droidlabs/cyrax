class Products::Decorator < Cyrax::Decorator
  def price
    resource.price_in_cents / 100.to_f
  end
end
