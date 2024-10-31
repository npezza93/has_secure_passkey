class HasSecurePasskey::OptionsForCreate
  class << self
    def verifier
      Rails.application.message_verifier("passkey_signup")
    end

    def from_message(message)
      new(**verifier.verify(message).symbolize_keys).tap do
        it.person.symbolize_keys! if it.person.is_a?(Hash)
      end
    end
  end

  def initialize(person:, options: nil, challenge: nil)
    @person = person
    @options = options
    @challenge = challenge
  end

  def message
    self.class.verifier.generate(
      { challenge:, options:,
        person: person.as_json(only: %i(email webauthn_id)) }.as_json
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

  attr_reader :person

  private

  def credential
    @credential ||= WebAuthn::Credential.options_for_create(
      user: { name: person.email, id: person.webauthn_id },
      exclude: person.passkeys.pluck(:external_id)
    )
  end
end
