class UserPolicy < ApplicationPolicy
  def create?
    user && user.is_admin
  end

  def update?
    user && record && user.id == record.id && user.is_admin == record.is_admin && user.is_trainer == record.is_trainer
  end

end