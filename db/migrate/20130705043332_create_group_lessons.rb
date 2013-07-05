class CreateGroupLessons < ActiveRecord::Migration
  def change
    create_table :group_lessons do |t|
      t.references :group
      t.references :lesson

      t.timestamps
    end
    add_index :group_lessons, :group_id
    add_index :group_lessons, :lesson_id
  end
end
