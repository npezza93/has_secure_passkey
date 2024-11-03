module HasSecurePasskey
  module ApplicationHelper
    def prompt_for_new_passkey(callback:, current_authenticatable: nil, **options)
      options_for_create =
        if current_authenticatable.present?
          HasSecurePasskey::OptionsForCreate.new(authenticatable: current_authenticatable)
        else
          HasSecurePasskey::OptionsForCreate.
            from_message(params[:webauthn_message])
        end

      tag.web_authn(nil, action: :create, callback:,
        options: options_for_create.to_json,
        message: options_for_create.message, **options)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      false
    end

    def login_with_passkey(callback:, **options)
      options_for_get = HasSecurePasskey::OptionsForGet.new

      tag.web_authn(nil, action: :get, callback:,
        options: options_for_get.to_json,
        message: options_for_get.message,
        **options)
    end

    def button_to_passkey_login(text, path = nil, **options, &block)
      if block_given?
        button_to has_secure_passkey.challenges_path(text), **options, &block
      else
        button_to text, has_secure_passkey.challenges_path(path), **options
      end
    end
  end
end
