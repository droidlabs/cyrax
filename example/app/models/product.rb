class Product < ActiveRecord::Base
  validates :vendor, presence:true

  belongs_to :user
end
