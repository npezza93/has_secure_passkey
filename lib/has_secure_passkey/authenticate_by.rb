class HasSecurePasskey::AuthenticateBy
  def initialize(model:, challenge:, params:)
    @model = model
    @challenge = challenge
    @params = params
  end

  def authenticated
    return @authenticated if defined?(@authenticated)

    @authenticated =
      if valid?
        passkey.authenticatable
      end
  end

  private

  attr_reader :challenge, :params, :model

  def valid?
    passkey.present? && verified? &&
      passkey.update(sign_count: webauthn_credential.sign_count) &&
      passkey.touch(:last_used_at)
  end

  def webauthn_credential
    @webauthn_credential ||= WebAuthn::Credential.from_get(params)
  end

  def passkey
    @passkey ||= Passkey.find_by(
      external_id: webauthn_credential.id, authenticatable_type: model.to_s
    )
  end

  def verified?
    webauthn_credential.verify(challenge, public_key: passkey.public_key,
                                          sign_count: passkey.sign_count)
  rescue WebAuthn::Error, WebAuthn::SignCountVerificationError
    false
  end
end
