require "test_helper"

class HasSecurePasskey::ChallengesControllerTest < ActionDispatch::IntegrationTest
  test "#create success" do
    post has_secure_passkey.challenges_path("/sessions"), as: :turbo_stream

    assert_response :success
  end
end
