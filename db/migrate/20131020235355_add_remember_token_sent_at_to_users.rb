class AddRememberTokenSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token_sent_at, :datetime
  end
end
