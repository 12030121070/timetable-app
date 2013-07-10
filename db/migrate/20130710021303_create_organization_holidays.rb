class CreateOrganizationHolidays < ActiveRecord::Migration
  def change
    create_table :organization_holidays do |t|
      t.date :date
      t.references :organization

      t.timestamps
    end
    add_index :organization_holidays, :organization_id
  end
end
