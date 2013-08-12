class AddLogotypeToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :logotype_uid,  :string
    add_column :organizations, :logotype_name, :string
  end
end
