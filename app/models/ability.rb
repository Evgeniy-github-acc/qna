# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    user_abilities if user

    can :read, :all  
  end
  

  def user_abilities
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
