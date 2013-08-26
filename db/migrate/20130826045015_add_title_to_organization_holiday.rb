class AddTitleToOrganizationHoliday < ActiveRecord::Migration
  def change
    add_column :organization_holidays, :title, :string
  end
end
