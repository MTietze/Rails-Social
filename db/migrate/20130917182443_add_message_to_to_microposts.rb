class AddMessageToToMicroposts < ActiveRecord::Migration
  def change
  	add_column :microposts, :message_to, :integer
  end
end
