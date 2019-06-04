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
    can :create, [Question, Answer, Commentary]
    can [:update, :destroy], [Question, Answer], author_id: user.id
    can :destroy, Commentary, author_id: user.id
    can :destroy, Commentary, author_id: user.id
    can [:up_vote, :down_vote], [Question, Answer] do |object|
      !author_of?(object)
    end

    can :best_solution, Answer do |answer|
      author_of?(answer.question)
    end
  end

  private

  def author_of?(object)
    object.author_id == user.id
  end
end
