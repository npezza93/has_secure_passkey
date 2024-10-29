module HasSecurePasskey
  module ApplicationHelper
    def prompt_for_new_passkey(callback:, **options)
      passkey_options =
        if authenticated?
          HasSecurePasskey::OptionsForCreate.new(person: Current.person).tap do |object|
            session[:challenge] = object.challenge
          end
        else
          HasSecurePasskey::OptionsForCreate.from_message(params[:token]).tap do |object|
            session[:webauthn] = { challenge: object.challenge, person: object.person }
          end
        end.to_json

      tag.web_authn(nil, action: :create, callback:, options: passkey_options,
        **options)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      false
    end

    def login_with_passkey(callback:, **options)
      passkey_options = HasSecurePasskey::OptionsForGet.new.tap do |object|
        session[:webauthn] = { challenge: object.challenge }
      end.to_json

      tag.web_authn(nil, action: :get, callback:, options: passkey_options,
        **options)
    end
  end
end
