class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :title
      t.string :address
      t.references :organization

      t.timestamps
    end
    add_index :buildings, :organization_id
  end
end
