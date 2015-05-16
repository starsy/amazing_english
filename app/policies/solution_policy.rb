class SolutionPolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    true
  end

  def edit?
    user && user.is_trainer
  end

  def destroy?
    user && user.is_trainer
  end

  def update?
    user && user.is_trainer
  end

  def create?
    user && user.is_trainer
  end

  def new?
    user && user.is_trainer
  end

end