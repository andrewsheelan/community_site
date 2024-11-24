class AddDescriptionToChatRooms < ActiveRecord::Migration[8.0]
  def change
    add_column :chat_rooms, :description, :text
  end
end
