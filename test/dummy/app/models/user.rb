class User < ApplicationRecord
  has_secure_passkey

  validates :email, presence: true, uniqueness: true
end
