class HasSecurePasskey::OptionsForCreate
  class << self
    def verifier
      Rails.application.message_verifier("passkey_signup")
    end

    def from_message(message)
      new(**verifier.verify(message).symbolize_keys).tap do
        _1.authenticatable.symbolize_keys! if _1.authenticatable.is_a?(Hash)
      end
    end
  end

  def initialize(authenticatable:, options: nil, challenge: nil)
    @authenticatable = authenticatable
    @options = options
    @challenge = challenge
  end

  def message
    self.class.verifier.generate(
      { challenge:, options:, authenticatable: authenticatable.as_json }.as_json
    )
  end

  def options
    @options ||= { publicKey: credential }
  end

  def as_json
    options
  end

  def challenge
    @challenge ||= credential.challenge
  end

  attr_reader :authenticatable

  private

  def credential
    @credential ||= WebAuthn::Credential.options_for_create(
      user: { name: authenticatable.email_address, id: authenticatable.webauthn_id },
      exclude: authenticatable.passkeys.pluck(:external_id)
    )
  end
end
