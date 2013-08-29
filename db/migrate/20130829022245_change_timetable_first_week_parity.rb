class ChangeTimetableFirstWeekParity < ActiveRecord::Migration
  def up
    remove_column :timetables, :first_week_parity
    add_column :timetables, :first_week_parity, :string
  end

  def down
    remove_column :timetables, :first_week_parity
    add_column :timetables, :first_week_parity, :integer
  end
end
