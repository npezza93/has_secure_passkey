require "test_helper"

class HasSecurePasskey::AuthenticateByTest < ActiveSupport::TestCase
  test "#authenticated" do
    user = users(:one)
    client = WebAuthn::FakeClient.new(WebAuthn.configuration.origin)
    webauthn_credential = WebAuthn::Credential.from_create(client.create)
    user.passkeys.create!(
      external_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count
    )
    challenge = WebAuthn::Credential.options_for_get.challenge

    login = HasSecurePasskey::AuthenticateBy.new(
      model: User, challenge:,
      params: ActionController::Parameters.new(client.get(challenge:))
    )

    assert_equal user, login.authenticated
  end

  test "#when verification fails" do
    user = users(:one)
    client = WebAuthn::FakeClient.new
    webauthn_credential = WebAuthn::Credential.from_create(client.create)
    user.passkeys.create(
      external_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count
    )
    challenge = WebAuthn::Credential.options_for_get.challenge

    login = HasSecurePasskey::AuthenticateBy.new(
      params: ActionController::Parameters.new(client.get(challenge:)),
      challenge:, model: User
    )

    assert_nil login.authenticated
  end
end
