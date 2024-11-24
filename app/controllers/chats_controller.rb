class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @messages = Message.in_order.includes(:user)
    @message = Message.new
  end

  def create
    @message = current_user.messages.build(message_params)

    if @message.save
      # Simulate AI response
      ai_response = Message.create!(
        content: generate_ai_response(@message.content),
        user: User.find_by(email: "ai.assistant@example.com"),
        ai_response: true
      )

      redirect_to chat_path, notice: "Message sent!"
    else
      @messages = Message.in_order.includes(:user)
      render :show
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def generate_ai_response(user_message)
    responses = [
      "That's a fascinating perspective! Let me think about that...",
      "I understand what you're saying. Here's what I think...",
      "Interesting point! Have you considered...",
      "Based on what you're saying, I would suggest...",
      "Let me share my thoughts on that..."
    ]

    # Add some delay to simulate thinking
    sleep(1)

    "#{responses.sample} #{user_message.reverse}"
  end
end
