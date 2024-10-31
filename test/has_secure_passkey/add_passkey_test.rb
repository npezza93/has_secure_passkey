require "test_helper"

class HasSecurePasskey::AddPasskeyTest < ActiveSupport::TestCase
  test "valid" do
    client = WebAuthn::FakeClient.new("http://example.com")
    challenge = WebAuthn::Credential.options_for_get.challenge
    params = ActionController::Parameters.new(web_authn_message: enc_message(challenge),
      **client.create(challenge:))

    assert_difference -> { users(:one).passkeys.count }, 1 do
      users(:one).add_passkey(params:)
    end
  end

  test "not valid" do
    client = WebAuthn::FakeClient.new
    challenge = WebAuthn::Credential.options_for_get.challenge
    params = ActionController::Parameters.new(web_authn_message: enc_message(challenge),
      **client.create(challenge:))

    assert_no_difference -> { users(:one).passkeys.count } do
      users(:one).add_passkey(params:)
    end
  end

  private

  def enc_message(challenge)
    HasSecurePasskey::OptionsForCreate.new(authenticatable: users(:one), challenge:).message
  end
end
