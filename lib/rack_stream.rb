# monkey-path Rack::Stream to add on_close support in open method
module Rack
  class Stream
    module Handlers
      class EventSource
        def open
          @es = ::Faye::EventSource.new(@app.env)
          @es.onopen = lambda do |event|
            @body.each {|c| @es.send(c)}
          end

          @es.onclose = lambda do |event|
            @app.close
          end
        end
      end
    end
  end
end
