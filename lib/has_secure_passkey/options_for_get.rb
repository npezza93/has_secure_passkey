class HasSecurePasskey::OptionsForGet
  class << self
    def verifier
      Rails.application.message_verifier("passkey_login")
    end

    def from_message(message)
      new(**verifier.verify(message).symbolize_keys)
    end
  end

  def initialize(challenge: nil)
    @challenge = challenge
  end

  def message
    self.class.verifier.generate({ challenge: })
  end

  def challenge
    @challenge ||= credential.challenge
  end

  def as_json
    credential.as_json
  end

  private

  def credential
    @credential ||= WebAuthn::Credential.
      options_for_get(user_verification: "discouraged")
  end
end
