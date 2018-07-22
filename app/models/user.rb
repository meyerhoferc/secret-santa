class User < ApplicationRecord
  has_secure_password

  attr_accessor :email, :first_name, :last_name,
                  :password, :password_confirmation

  validates_uniqueness_of :email
end
