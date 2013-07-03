class AddEmailToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :email, :string
  end
end
