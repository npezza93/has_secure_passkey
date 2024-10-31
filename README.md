# HasSecurePasskey

HasSecurePasskey is part generator, part cinceptual compression of a passkey
implementation. Implementing passkeys is more complex than regular passwords
but they have the added benefit of being more secure and easier for end users
to use.

## Usage

If you want to use the full implementation run the `bin/rails passkeys`
generator which sets up models, controllers, and a mailer for the whole
registration and session flow.

Alternatively, you can just use the helpers provided by `has_secure_passkey` and
the view helpers and make everything else yourself.


## Installation
Add this line to your application's Gemfile:

```ruby
gem "has_secure_passkey"
```

And then execute:
```bash
$ bundle
$ bin/rails passkeys
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
