require 'issuer/notifier'

# This is the guy that catches those pesky unhandled exceptions.
module Issuer
  module Catcher

    # Sets up an alias chain to catch exceptions when Rails does
    def self.included(base) #:nodoc:
      # base.send(:alias_method, :issuer_rescue_from, :rescue_from)
      base.send(:alias_method, :proceed_to_rescue_normally, :rescue_action)
      base.send(:alias_method, :rescue_action, :handle_exception_and_carry_on)
    end

    def handle_exception_and_carry_on(exception)
      Issuer::Notifier.notify(exception)
      proceed_to_rescue_normally(exception)
    end

    # notify then let it explode anyway
    def handle_exception_with_issuer(exception)
      Issuer::Notifier.notify(exception)
    end

  end
end
