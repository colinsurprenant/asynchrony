module Rack
  class Sse
    include Rack::Utils

    def initialize(app)
      @app = app
    end

    def call(env)
      return not_acceptable_error unless is_sse?(env)
      @app.call(env)
      [200, {'Content-Type' => 'text/event-stream'}, []]
    end

    private

    def is_sse?(env)
      env['HTTP_ACCEPT'] == 'text/event-stream'
    end

    def not_acceptable_error
      body = "{\"error\" : 406, \"message\" : \"Not acceptable\"}"
      [406, {'Content-Type' => 'application/json', 'Content-Length' => body.size.to_s}, [body]]
    end

  end
end