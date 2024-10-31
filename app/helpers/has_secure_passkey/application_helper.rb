module HasSecurePasskey
  module ApplicationHelper
    def prompt_for_new_passkey(callback:, **options)
      options_for_create =
        if authenticated?
          HasSecurePasskey::OptionsForCreate.new(person: Current.person)
        else
          HasSecurePasskey::OptionsForCreate.
            from_message(params[:web_authn_message])
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
  end
end
