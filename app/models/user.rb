class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 } , if: :pwd_and_confirm_both_exists?
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: :pwd_and_confirm_both_exists?

  validates :email, uniqueness: true

  def pwd_and_confirm_both_exists?
    if password.nil? and password_confirmation.nil?
      return false
    end

    if password.blank? and password_confirmation.blank?
      return false
    end

  end
end
