class HasSecurePasskey::OptionsForGet
  delegate :challenge, to: :credential

  def credential
    @credential ||= WebAuthn::Credential.
      options_for_get(user_verification: "discouraged")
  end

  def as_json
    { publicKey: credential.as_json }
  end
end
