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
  
  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    can :read, :all
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], author_id: user.id
    can :destroy, [Question, Answer, Comment], author_id: user.id
    can :destroy, Link,  linkable: { author_id: user.id }
    can :destroy, Award, question: { author_id: user.id }
    can :mark_best, Answer, question: { author_id: @user.id }
    can :destroy, ActiveStorage::Attachment do |resource|
      user.author_of?(resource.record)
    end
    can :vote, Votable do |votable|
      !@user.author_of?(votable)
    end
  end
end
