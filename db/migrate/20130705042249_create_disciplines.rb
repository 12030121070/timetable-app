class CreateDisciplines < ActiveRecord::Migration
  def change
    create_table :disciplines do |t|
      t.text :title
      t.references :organization
      t.string :abbr

      t.timestamps
    end
    add_index :disciplines, :organization_id
  end
end
