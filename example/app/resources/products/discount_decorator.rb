class Products::DiscountDecorator < Cyrax::Decorator
  def price
    resource.price_in_cents / 100.to_f*0.8
    111
  end
end
