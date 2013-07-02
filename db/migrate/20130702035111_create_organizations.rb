class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.text :title
      t.string :email
      t.string :phone
      t.string :site
      t.string :subdomain

      t.timestamps
    end
  end
end
