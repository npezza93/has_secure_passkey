class HasSecurePasskey::AddPasskey
  def initialize(authenticatable:, params:)
    @authenticatable = authenticatable
    @params = params
  end

  def save
    if valid?
      passkey.save
      passkey
    else
      false
    end
  end

  private

  attr_reader :authenticatable, :params

  delegate_missing_to :credential

  def credential
    @credential ||= WebAuthn::Credential.from_create(params)
  end

  def valid?
    credential.verify(challenge)
  rescue WebAuthn::Error => e
    authenticatable.errors.add(:passkeys, e.message)
    false
  end

  def passkey
    @passkey ||= authenticatable.passkeys.build(
      external_id: credential.id, public_key:, sign_count:
    )
  end

  def challenge
    HasSecurePasskey::OptionsForCreate.
      from_message(params[:webauthn_message]).challenge
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    ""
  end
end
