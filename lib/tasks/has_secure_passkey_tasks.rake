desc "Install passkeys"
task :passkeys do
  Rails::Command.invoke :generate, [ "has_secure_passkey:passkeys" ]
  Rails::Command.invoke "db:encryption:init"
end
