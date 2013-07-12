class AddStateToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :active, :boolean, :default => false
  end
end
