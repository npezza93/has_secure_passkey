require "test_helper"

class HasSecurePasskey::AuthenticateByTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @client = WebAuthn::FakeClient.new("http://example.com")
    webauthn_credential = WebAuthn::Credential.from_create(@client.create)
    @passkey = @user.passkeys.create(
      external_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count
    )
  end

  test "#authenticated" do
    @client.create(rp_id: URI.parse(WebAuthn.configuration.origin).host)
    challenge = WebAuthn::Credential.options_for_get.challenge

    login = HasSecurePasskey::AuthenticateBy.new(
      model: User, params: ActionController::Parameters.new(
        web_authn_message: enc_message(challenge), **@client.get(challenge:)
      )
    )

    assert_equal @user, login.authenticated
  end

  test "#when verification fails" do
    @client.create(rp_id: URI.parse(WebAuthn.configuration.origin).host)
    challenge = WebAuthn::Credential.options_for_get.challenge

    login = HasSecurePasskey::AuthenticateBy.new(
      model: User, params: ActionController::Parameters.new(
        web_authn_message: enc_message("blah"), **@client.get(challenge:)
      )
    )

    assert_nil login.authenticated
  end

  private

  def enc_message(challenge)
    HasSecurePasskey::OptionsForGet.new(challenge:).message
  end
end
