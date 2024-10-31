desc "Install passkeys"
task :passkeys do
  Rails::Command.invoke :generate, [ "has_secure_passkey:passkeys" ]
end
