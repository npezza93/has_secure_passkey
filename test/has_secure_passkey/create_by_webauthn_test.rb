require "test_helper"

class HasSecurePasskey::CreateByWebauthnTest < ActiveSupport::TestCase
  setup do
    @client = WebAuthn::FakeClient.new(WebAuthn.configuration.origin)
    @challenge = WebAuthn::Credential.options_for_get.challenge
  end

  test "#create_by_webauthn success" do
    assert_difference -> { User.count } do
      assert_difference -> { Passkey.count } do
        user =  User.create_by_webauthn(params: params(email_address: "foo@bar.com", webauthn_id: "123"))
        assert user.persisted?
        assert_equal "foo@bar.com", user.email_address
      end
    end
  end

  test "#create_by_webauthn with bad person data" do
    assert_no_difference -> { User.count } do
      assert_no_difference -> { Passkey.count } do
        user = User.create_by_webauthn(params: params(email_address: "  ", webauthn_id: "123"))
        assert_not user.persisted?
      end
    end
  end

  test "#create_by_webauthn when webauthn raises" do
    assert_no_difference -> { User.count } do
      assert_no_difference -> { Passkey.count } do
        user = User.create_by_webauthn(params: params(
          challenge: WebAuthn::Credential.options_for_get.challenge,
          email_address: "email@wemail.com", webauthn_id: "123")
        )
        assert_not user.persisted?
      end
    end
  end

  test "errors when user fails" do
    user = User.create_by_webauthn(params: params(email_address: "  ", webauthn_id: "123"))
    assert_equal "Email can't be blank", user.errors.full_messages.join(", ")
  end

  test "errors when webauthn fails" do
    user = User.create_by_webauthn(params: params(
      challenge: WebAuthn::Credential.options_for_get.challenge,
      email_address: "email@wemail.com", webauthn_id: "123")
    )

    assert_equal "Passkeys WebAuthn::ChallengeVerificationError", user.errors.full_messages.join(",")
  end

  private

  def params(challenge: @challenge, **user_params)
    ActionController::Parameters.new(
      webauthn_message: HasSecurePasskey::OptionsForCreate.new(
        authenticatable: User.new(user_params), challenge:
      ).message,
      **@client.create(challenge: @challenge)
    )
  end
end
