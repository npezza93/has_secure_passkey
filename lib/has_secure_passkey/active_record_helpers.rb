module HasSecurePasskey::ActiveRecordHelpers
  def has_secure_passkey
    encrypts :webauthn_id, deterministic: true

    has_many :sessions, dependent: :destroy
    has_many :passkeys, dependent: :delete_all, as: :authenticatable
    validates :webauthn_id, uniqueness: true

    accepts_nested_attributes_for :passkeys

    define_singleton_method :webauthn_id do
      WebAuthn.generate_user_id
    end

    define_singleton_method :authenticate_by do |challenge:, params:|
      HasSecurePasskey::AuthenticateBy.
        new(model: self, challenge:, params:).
        authenticated
    end
  end
end
