module Rack
  class Sse

    def initialize(app)
      @app = app
    end

    def call(env)
      if is_sse?(env)
        @app.call(env)
        [200, {'Content-Type' => 'text/event-stream'}, []]
      else
        [406, {'Content-Type' => 'application/json'}, ["{\"error\" : 406, \"message\" : \"Not acceptable - expecting server-sent event request\"}"]]
      end
    end

    private

    def is_sse?(env)
      env['HTTP_ACCEPT'] == 'text/event-stream'
    end

  end
end