class Ability
  include CanCan::Ability

  def initialize user
    can :read, Comment
    can :read, Post

    return unless user

    if user.has_role? :user
      can :manage, User, id: user.id
      can :manage, [Post, Comment], user_id: user.id
    end

    can :manage, :all if user.has_role? :admin
  end
end
