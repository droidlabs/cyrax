class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :vendor
      t.string :model
      t.text :description
      t.integer :price_in_cents

      t.timestamps
    end
  end
end
