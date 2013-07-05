class CreateClassroomLessons < ActiveRecord::Migration
  def change
    create_table :classroom_lessons do |t|
      t.references :classroom
      t.references :lesson

      t.timestamps
    end
    add_index :classroom_lessons, :classroom_id
    add_index :classroom_lessons, :lesson_id
  end
end
