Devise::TokenAuthenticatable.setup do |config|
  # set the authentication key name used by this module,
  # defaults to :auth_token
  config.token_authentication_key = :auth_token

end
