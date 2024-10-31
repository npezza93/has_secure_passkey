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

    define_singleton_method :authenticate_by do |params:|
      HasSecurePasskey::AuthenticateBy.
        new(model: self, params:).
        authenticated
    end

    define_method :add_passkey do |params:|
      HasSecurePasskey::AddPasskey.
        new(authenticatable: self, params:).
        save
    end
  end
end
