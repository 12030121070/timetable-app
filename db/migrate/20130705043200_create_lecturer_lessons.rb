class CreateLecturerLessons < ActiveRecord::Migration
  def change
    create_table :lecturer_lessons do |t|
      t.references :lesson
      t.references :lecturer

      t.timestamps
    end
    add_index :lecturer_lessons, :lesson_id
    add_index :lecturer_lessons, :lecturer_id
  end
end
