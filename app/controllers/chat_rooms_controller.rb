class ChatRoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room, only: [ :show ]

  def index
    @chat_rooms = ChatRoom.public_rooms
    @private_rooms = current_user.chat_rooms.private_rooms
    @users = User.where.not(id: current_user.id)
    @chat_room = ChatRoom.new
  end

  def show
    unless @chat_room.member?(current_user)
      redirect_to chat_rooms_path, alert: "You don't have access to this chat room."
      return
    end

    @messages = @chat_room.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
    @room_members = @chat_room.users.where.not(id: current_user.id)
  end

  def create
    if params[:user_id]
      other_user = User.find(params[:user_id])
      @chat_room = current_user.start_conversation_with(other_user)
    else
      @chat_room = ChatRoom.new(chat_room_params)
      @chat_room.private = false

      if @chat_room.save
        @chat_room.chat_room_members.create(user: current_user)
      end
    end

    if @chat_room.persisted?
      redirect_to @chat_room
    else
      redirect_to chat_rooms_path, alert: "Could not create chat room."
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name)
  end
end
