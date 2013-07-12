class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.integer :cost
      t.integer :min_group
      t.integer :max_group
      t.integer :min_month
      t.integer :max_month
      t.integer :discount_year
      t.integer :discount_half_year
      t.integer :discount_small
      t.integer :discount_medium
      t.integer :discount_large

      t.timestamps
    end
  end
end
