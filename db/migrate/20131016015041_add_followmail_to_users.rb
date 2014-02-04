class AddFollowmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :followmail, :boolean, default: true
  end
end
