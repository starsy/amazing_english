class EventPolicy < ApplicationPolicy
  def new?
    user && user.is_trainer
  end

  def create?
    user && user.is_trainer
  end

  def update?
    user && user.is_trainer
  end

  def destory?
    user && user.is_trainer
  end
end