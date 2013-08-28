class RemoveLogotypeUidAndLogotypeNameFromOrganization < ActiveRecord::Migration
  def change
    remove_column :organizations, :logotype_uid
    remove_column :organizations, :logotype_name
  end
end
