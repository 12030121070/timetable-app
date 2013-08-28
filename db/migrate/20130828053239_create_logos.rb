class CreateLogos < ActiveRecord::Migration
  def change
    create_table :logos do |t|
      t.references :organization
      t.attachment :image

      t.timestamps
    end
    add_index :logos, :organization_id
  end
end
