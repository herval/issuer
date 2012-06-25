require 'rails'
require 'issuer/rack_rails'
require 'issuer/catcher'

module Issuer
  class Railtie < Rails::Railtie

    initializer "issuer.middleware" do |app|
      app.config.middleware.use "Issuer::RackRails"
    end

    config.after_initialize do


      if defined?(ActionController)
        ::ActionController::Base.send(:include, Issuer::Catcher)

        puts "[Issuer] Issuer is not properly configured! Please configure api_token, username, repo and fallback_email" if Issuer.api_token.blank?
      end
    end
  end
end
