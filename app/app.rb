class App < Sinatra::Base

  show_sinatra_exception = lambda do |env, e|
    app = Sinatra::ShowExceptions.new(lambda {|env| raise e})
    app.call(env)
  end

  configure do
    enable :logging
    set :threaded, false
    set :app_title, 'Asynchrony'
    set :root, File.dirname(__FILE__)
    use Rack::Asynchrony, {:exception_handler => show_sinatra_exception}
    use Rack::CommonLogger, Logger.new(STDOUT)
  end

  get "/now" do
    content_type "text/plain"
    body "now from #{Fiber.current} at #{Time.now}"
  end

  # non blocking sleep using EM::Synchrony
  get "/delayed" do
    EM::Synchrony.sleep(10)
    content_type "text/plain"
    body "delayed from #{Fiber.current} at #{Time.now}"
  end

  # blocking sleep, everything will freeze
  get "/blocking" do
    sleep(10)
    content_type "text/plain"
    body "blocking from #{Fiber.current} at #{Time.now}"
  end

  # non blocking defer using eventmachine thread pool
  get "/nonblocking" do
    EM::Synchrony.defer do
      sleep(10)
      content_type "text/plain"
      body "nonblocking from #{Fiber.current} at #{Time.now}"
    end
  end

  get "/bang" do
    raise("bang")
  end

end
