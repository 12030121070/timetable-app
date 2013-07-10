class AddSubgroupToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :subgroup, :string
  end
end
