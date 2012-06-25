module Issuer  
  class RackRails    

    def initialize(app)
      @app = app
    end    
    
    def call(env)
      begin
        body = @app.call(env)
      rescue Exception => e
        env['action_controller.instance'].handle_exception_with_issuer(e)
        raise
      end

      if env['rack.exception']
        env['action_controller.instance'].handle_exception_with_issuer(env['rack.exception'])
      end

      body
    end      
  end
end
