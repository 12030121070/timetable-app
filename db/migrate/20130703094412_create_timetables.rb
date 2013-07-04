class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.references :organization
      t.string :title
      t.date :starts_on
      t.date :ends_on
      t.string :status
      t.boolean :parity

      t.timestamps
    end
    add_index :timetables, :organization_id
  end
end
