class CreateLecturers < ActiveRecord::Migration
  def change
    create_table :lecturers do |t|
      t.string :name
      t.string :patronymic
      t.string :surname
      t.references :organization

      t.timestamps
    end
    add_index :lecturers, :organization_id
  end
end
