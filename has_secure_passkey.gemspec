require_relative "lib/has_secure_passkey/version"

Gem::Specification.new do |spec|
  spec.name        = "has_secure_passkey"
  spec.version     = HasSecurePasskey::VERSION
  spec.authors     = [ "Nick Pezza" ]
  spec.email       = [ "pezza@hey.com" ]
  spec.homepage    = "https://github.com/npezza93/has_secure_passkey"
  spec.summary     = "Add passkey support to Rails"
  spec.license     = "MIT"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.0.rc2"
  spec.add_dependency "webauthn"
end
