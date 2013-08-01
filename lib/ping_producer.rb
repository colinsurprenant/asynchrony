require 'eventmachine'

module PingProducer
  def channel
    @channel ||= EM::Channel.new
    @producer ||= self.detach_fake_producer
    @channel
  end

  private

  def self.detach_fake_producer
    Thread.new do
      Thread.current.abort_on_exception = true
      loop do
        sleep(1)
        @channel << "{\"ping\" : {\"date\" : \"#{Time.now.to_s}\", \"msg\" : \"some message\"}}"
      end
    end
  end

  module_function :channel
end