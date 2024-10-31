HasSecurePasskey::Engine.routes.draw do
  post "/challenges/:session_path", to: "challenges#create", as: :challenges
end
