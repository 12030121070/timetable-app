class CreateLessonTimes < ActiveRecord::Migration
  def change
    create_table :lesson_times do |t|
      t.references :context, :polymorphic => true
      t.string :starts_at
      t.string :ends_at
      t.integer :day
      t.integer :number

      t.timestamps
    end
    add_index :lesson_times, :context_id
    add_index :lesson_times, :context_type
  end
end
