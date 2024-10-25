module HasSecurePasskey
  class Engine < ::Rails::Engine
    isolate_namespace HasSecurePasskey

    initializer "has_secure_passkey.assets" do
      if Rails.application.config.respond_to?(:assets)
        Rails.application.config.assets.precompile += %w( has_secure_passkey.js )
      end
    end

    initializer "has_secure_passkey.importmap", before: "importmap" do |app|
      if Rails.application.respond_to?(:importmap)
        app.config.importmap.paths << Engine.root.join("config/importmap.rb")
      end
    end
  end
end
