class HomeController < ApplicationController
  def index
    @users = User.all
    if user_signed_in?
      @recent_conversations = current_user.joined_chat_rooms
        .includes(:users, messages: :user)
        .order('messages.created_at DESC')
        .distinct
        .limit(5)

      @upcoming_events = Event.where(
        'start_time BETWEEN ? AND ?',
        Date.current.beginning_of_month,
        Date.current.end_of_month.end_of_day
      )

      @recent_posts = Post.includes(:user)
        .order(created_at: :desc)
        .limit(5)
    end
  end
end
