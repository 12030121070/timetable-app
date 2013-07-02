class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.string :number
      t.references :building

      t.timestamps
    end
    add_index :classrooms, :building_id
  end
end
