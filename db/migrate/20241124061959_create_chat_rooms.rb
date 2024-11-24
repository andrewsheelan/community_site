class CreateChatRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_rooms do |t|
      t.string :name
      t.boolean :private

      t.timestamps
    end
  end
end