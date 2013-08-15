class AddClassromsIndex < ActiveRecord::Migration
  def up
    add_index :classrooms, [ :building_id, :number ], :unique => true
  end

  def down
    remove_index :classrooms, :column => [ :building_id, :number ]
  end
end
