class AddUserToChatRooms < ActiveRecord::Migration[8.0]
  def up
    # First add the column as nullable
    add_reference :chat_rooms, :user, null: true, foreign_key: true

    # Update existing records to use the first member as the owner
    execute <<-SQL
      UPDATE chat_rooms
      SET user_id = (
        SELECT user_id
        FROM chat_room_members
        WHERE chat_room_members.chat_room_id = chat_rooms.id
        LIMIT 1
      )
    SQL

    # Now make the column non-nullable
    change_column_null :chat_rooms, :user_id, false
  end

  def down
    remove_reference :chat_rooms, :user
  end
end
