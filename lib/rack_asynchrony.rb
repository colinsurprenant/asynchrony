require 'eventmachine'
require 'fiber'

module Rack
  class Asynchrony

    DEFAULT_EXCEPTION_HANDLER = lambda do |env, e|
      [500, {'Content-Type' => 'text/plain'}, [["#{e.class}: #{e.message}: ", *e.backtrace].join("\n\t")]]
    end

    def initialize(app, options = {})
      @app = app
      @exception_handler = options[:exception_handler] || DEFAULT_EXCEPTION_HANDLER
    end

    def call(env)
      fiber = Fiber.new do
        begin
          result = @app.call(env)
          env["async.callback"].call(result)
        rescue Exception => e
          env["async.callback"].call(@exception_handler.call(env, e))
        end
      end
      EM.next_tick {fiber.resume}

      throw :async
    end
  end
end
