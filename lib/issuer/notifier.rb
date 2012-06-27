require 'github-v3-api'

module Issuer
  class Notifier
    
    def self.notify(exception)
      begin
        params = {:title => exception_title(exception), :body => exception_body(exception), :labels => ["issuer"]}

        @@api ||= GitHubV3API.new(Issuer.api_token)
        # TODO replace this by a search: http://developer.github.com/v3/search/#search-issues
        existing = @@api.issues.list(:user => Issuer.user, :repo => Issuer.repo, :labels => "issuer")
        issue = existing.select { |s| s.title == params[:title] }

        if issue
          if issue.state != 'open'
            # TODO reopen and leave a comment
          else
            # TODO leave a comment, maybe?
          end
        else
          issue = @@api.issues.create(Issuer.user, Issuer.repo, params)
          puts "New issue registered: #{issue.id} - #{issue.title}"
        end
      rescue => e
        puts "[Issuer] There was an error posting exception to GitHub: #{e.message} - the full backtrace was sent to the fallback email"
        # TODO send email
      end
    end
    
    private
    
    def self.exception_title(exception)
      exception.to_s
    end
    
    def self.exception_body(exception)
      info = [
        ["Class", exception.class.to_s],
        ["Time", Time::now],
        ["Message", exception.message],
        ["Backtrace", exception.backtrace.join("\n")],
      ]
      info.collect{ |k, v| "#{k}: #{v}" }.join("\n")
    end
  end
end
