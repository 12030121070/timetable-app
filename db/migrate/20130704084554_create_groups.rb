class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.references :timetable

      t.timestamps
    end
    add_index :groups, :timetable_id
  end
end
