class AnswerPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def update?
    user && user.is_trainer
  end

  def destroy?
    user && user.is_trainer
  end

  def index?
    true
  end

  def show_answer?
    user && user.is_trainer
  end

  def show?
    user && user.is_trainer
  end

end