class HasSecurePasskey::Recovery
  def initialize(model:, params:)
    @model = model
    @params = params
  end

  def run
    old_passkeys = authenticatable.passkeys.to_a

    ActiveRecord::Base.transaction do
      (authenticatable.update(webauthn_id:) &&
        authenticatable.add_passkey(params:) &&
        old_passkeys.all?(&:destroy) && authenticatable) ||
      raise(ActiveRecord::Rollback)
    end
  end

  private

  attr_reader :params, :model

  def authenticatable
    model.find(options.authenticatable[:id])
  end

  def webauthn_id
    options.authenticatable[:webauthn_id]
  end

  def options
    HasSecurePasskey::OptionsForCreate.from_message(params[:webauthn_message])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    ""
  end
end
