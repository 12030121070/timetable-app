class CreateLecturers < ActiveRecord::Migration
  def change
    create_table :lecturers do |t|
      t.string :name
      t.string :patronymic
      t.string :surname
      t.string :academic_degree
      t.string :academic_rank
      t.string :photo
      t.text :bio
      t.references :organization

      t.timestamps
    end
    add_index :lecturers, :organization_id
  end
end
