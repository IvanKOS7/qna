# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment], user_id: user.id
    can :update, [Question, Answer], user_id: user.id
    can :edit, [Question, Answer], user_id: user.id
    can :subscribe, [Question], user_id: user.id
    can :unsubscribe, [Question], user_id: user.id
  end
end
