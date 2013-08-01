$: << File.expand_path(File.dirname(__FILE__) + '/..')

require 'bundler/setup'
require 'eventmachine'
require 'rack'
require 'sinatra/base'
require 'thin'
require 'grape'
require "em-synchrony"
require 'rack/stream'
require 'fiber'
require 'logger'

require 'lib/rack_sse'
require 'lib/rack_asynchrony'
require 'lib/rack_stream'
require 'lib/ping_producer'
require 'app/app.rb'
require 'app/api.rb'

# required for rack logging
class Logger; alias_method :write, :<<; end

def boot(options = {})
  server = options[:server] || 'thin'
  host = options[:host] || '0.0.0.0'
  port = options[:port] || '9000'

  app = Rack::Builder.app do
    use Rack::CommonLogger, Logger.new(STDOUT)

    use Rack::Static,
      :root => File.expand_path(File.dirname(__FILE__) + "/public"),
      :index => 'index.html'

    run Rack::Cascade.new([Api.new, App.new])
  end

  EM.run do
    Rack::Server.start({
      :app => app,
      :server => server,
      :Host => host,
      :Port => port,
    })
  end
end

boot