class User < ApplicationRecord
  has_secure_passkey

  validates :email_address, presence: true, uniqueness: true
end
