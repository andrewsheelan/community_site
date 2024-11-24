class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    else
      can :read, :all

      if user.persisted? # logged in user
        can :create, Post
        can [ :update, :destroy ], Post, user_id: user.id
        can [ :publish, :unpublish ], Post, user_id: user.id

        can :create, Event
        can [ :update, :destroy ], Event, user_id: user.id
        can [ :join, :leave ], Event

        can :create, Comment
        can :destroy, Comment, user_id: user.id

        can :create, ChatRoom
        can [ :update, :destroy ], ChatRoom, user_id: user.id
        can :create, Message
      end
    end
  end
end
