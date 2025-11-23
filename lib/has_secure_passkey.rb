require "webauthn"

require "has_secure_passkey/version"
require "has_secure_passkey/engine"
require "has_secure_passkey/options_for_create"
require "has_secure_passkey/options_for_get"
require "has_secure_passkey/active_record_helpers"
require "has_secure_passkey/recovery"
require "has_secure_passkey/authenticate_by"
require "has_secure_passkey/add_passkey"

module HasSecurePasskey
  def self.find_recovery_token(token)
    GlobalID::Locator.
      locate_signed(token, for: :recovery).
      tap { it&.reset_webauthn_id } || raise(ActiveRecord::RecordNotFound)
  end
end
