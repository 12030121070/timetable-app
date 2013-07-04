class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.references :timetable
      t.integer :number
      t.date :starts_on
      t.string :parity

      t.timestamps
    end
    add_index :weeks, :timetable_id
  end
end
