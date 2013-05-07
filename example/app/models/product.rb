class Product < ActiveRecord::Base
  attr_accessible :description, :model, :price_in_cents, :vendor

  validates :vendor, presence:true

  belongs_to :user
end
