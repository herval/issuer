module Issuer
  mattr_accessor :api_token, :user, :repo, :fallback_email
end

require 'issuer/railtie' if defined?(Rails)