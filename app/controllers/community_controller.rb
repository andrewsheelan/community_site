class CommunityController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
                 .order(created_at: :desc)
  end

  def start_chat
    other_user = User.find(params[:user_id])
    chat_room = current_user.start_conversation_with(other_user)

    if chat_room
      redirect_to chat_room_path(chat_room), notice: "Chat started with #{other_user.name}"
    else
      redirect_to community_path, alert: "Couldn't start chat"
    end
  end
end
