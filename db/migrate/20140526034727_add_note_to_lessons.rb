class AddNoteToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :note, :text
  end
end
