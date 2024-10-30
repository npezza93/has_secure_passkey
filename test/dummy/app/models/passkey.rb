class Passkey < ApplicationRecord
  belongs_to :authenticatable, polymorphic: true
end
