class UserPolicy < ApplicationPolicy

  def index?
    true
  end

  def new?
    user && user.is_admin
  end

  def create?
    user && user.is_admin
  end

  def update?
    return false if user.nil?
    return true if user.is_admin
    return record && user.id == record.id && user.is_trainer == record.is_trainer
  end

end