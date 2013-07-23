class AddSumToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :sum, :integer
  end
end
