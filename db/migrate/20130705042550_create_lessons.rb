class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.references :day
      t.references :discipline
      t.references :lesson_time
      t.string :kind

      t.timestamps
    end
    add_index :lessons, :day_id
    add_index :lessons, :discipline_id
    add_index :lessons, :lesson_time_id
  end
end
