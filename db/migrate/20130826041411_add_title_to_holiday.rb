class AddTitleToHoliday < ActiveRecord::Migration
  def change
    add_column :holidays, :title, :string
  end
end
