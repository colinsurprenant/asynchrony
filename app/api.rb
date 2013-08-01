class Api < Grape::API
  prefix 'api'
  version 'v1', :using => :path

  use Rack::Stream
  use Rack::Sse

  helpers do
    include Rack::Stream::DSL
    def logger; Grape::API.logger; end
  end

  namespace :stream do

    get "/" do
      after_open do
        @sid = PingProducer.channel.subscribe do |data|
          chunk(data)
        end
        logger.info("subscribed channel #{@sid}")
      end

      after_close do
        PingProducer.channel.unsubscribe(@sid)
        logger.info("unsubscribed channel #{@sid}")
      end
    end
  end
end
