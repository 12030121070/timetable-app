class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :organization
      t.date :start_on
      t.date :ends_on
      t.integer :groups_count

      t.timestamps
    end
    add_index :subscriptions, :organization_id
  end
end
