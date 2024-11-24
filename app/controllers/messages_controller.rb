class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_room

  def create
    @message = @chat_room.messages.build(message_params.merge(user: current_user))

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_room_path(@chat_room) }
      end
    else
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            'new_message',
            partial: 'messages/form',
            locals: { message: @message, chat_room: @chat_room }
          )
        }
        format.html { redirect_to chat_room_path(@chat_room), alert: 'Message could not be sent.' }
      end
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:chat_room_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
