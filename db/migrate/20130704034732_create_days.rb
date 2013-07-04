class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.references :week
      t.date :date
      t.string :status

      t.timestamps
    end
    add_index :days, :week_id
  end
end
