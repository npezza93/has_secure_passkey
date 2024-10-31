# frozen_string_literal: true

class HasSecurePasskey::PasskeysGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def create_passkey_files
    template "app/models/session.rb"
    template "app/models/person.rb"
    template "app/models/current.rb"
    template "app/models/passkey.rb"

    template "app/controllers/concerns/authentication.rb"

    template "app/controllers/registrations_controller.rb"
    template "app/views/registrations/create.turbo_stream.erb"
    template "app/views/registrations/new.html.erb"

    template "app/controllers/email_verifications_controller.rb"
    template "app/views/email_verifications/show.html.erb"

    template "app/controllers/people_controller.rb"

    template "app/controllers/sessions_controller.rb"

    template "app/channels/application_cable/connection.rb" if defined?(ActionCable::Engine)

    template "app/mailers/email_verification_mailer.rb"

    template "app/views/email_verification_mailer/verify.html.erb"
    template "app/views/email_verification_mailer/verify.text.erb"

    template "test/mailers/previews/email_verification_mailer_preview.rb"
  end

  def configure_application_controller
    inject_into_class "app/controllers/application_controller.rb", "ApplicationController", "  include Authentication\n"
  end

  def configure_passkey_routes
    route "resource :sessions, only: :destroy"
    route "resources :sessions, only: :create"
    route "resources :people, only: :create"
    route "resources :email_verifications, only: :show, param: :webauthn_message"
    route "resource :registration, only: %i(new create)"
    route "mount HasSecurePasskey::Engine => \"/has_secure_passkey\""
  end

  def add_migrations
    generate "migration", "CreatePeople", "email_address:string!:uniq webauthn_id:string!", "--force"
    generate "migration", "CreateSessions", "person:references ip_address:string user_agent:string", "--force"
    generate "migration", "CreatePasskeys", "authenticatable:references{polymorphic} external_id:string public_key:string sign_count:integer last_used_at:datetime name:string", "--force"
  end
end
