require 'github-v3-api'

module Issuer
  class Notifier
    
    def self.notify(exception)
      begin
        params = {:title => exception_title(exception), :body => exception_body(exception)}

        binding.pry
        @@api ||= GitHubV3API.new(Issuer.api_token)
        puts api
        # TODO detect if exists already?
        @@api.issues.create(Issuer.user, Issuer.repo, params)
        # TODO log
      rescue => e
        puts e
        # TODO send email
        # TODO log?
        # in the meantime, just let it go...
      end
    end
    
    private
    
    def self.exception_title(exception)
      exception.to_s
    end
    
    def self.exception_body(exception)
      exception.backtrace ? exception.backtrace.join("\n") : "No backtrace provided"
    end
  end
end
