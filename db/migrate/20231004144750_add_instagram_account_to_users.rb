class AddInstagramAccountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :instagram_account, :boolean, default: true
  end
end
