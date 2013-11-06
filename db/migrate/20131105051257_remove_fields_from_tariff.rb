class RemoveFieldsFromTariff < ActiveRecord::Migration
  def change
    remove_column :tariffs, :discount_half_year
    remove_column :tariffs, :discount_year
  end
end
