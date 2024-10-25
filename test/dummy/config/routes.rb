Rails.application.routes.draw do
  mount HasSecurePasskey::Engine => "/has_secure_passkey"
end
