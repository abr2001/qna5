class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    cannot :manage, :profile
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :rate, [Question, Answer] do |ratable|
      ratable.user_id != user.id
    end
    can :cancel_rate, [Question, Answer] do |ratable|
      ratable.user_id != user.id
    end
    can :create, [Question, Answer, Comment, Attachment]
    can :update, [Question, Answer], user_id: user.id
    can :set_best, Answer do |answer|
      answer.question.user_id == user.id && !answer.best
    end
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end
  end


end
