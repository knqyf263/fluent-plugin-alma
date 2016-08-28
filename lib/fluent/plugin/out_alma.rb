require 'fluent/output'

require 'alma-client'

module Fluent
  class AlmaOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('alma', self)

    config_set_default :flush_interval, 1 # 1sec

    config_param :alma, :string, :default => 'localhost:11235'

    config_param :connect_timeout, :integer, :default => nil
    config_param :send_timeout, :integer, :default => nil
    config_param :receive_timeout, :integer, :default => nil

    config_param :target, :string, :default => nil

    # for test
    attr_reader :host, :port

    def initialize
      super
    end

    def configure(conf)
      super

      @host, @port = @alma.split(':', 2)
      @port = @port.to_i

      if @target.nil?
        raise Fluent::ConfigError, 'target naming not specified'
      end
    end

    def client(opts={})
      Alma::Client.new(@host, @port, {
        :connect_timeout => opts[:connect_timeout] || @connect_timeout,
        :send_timeout    => opts[:send_timeout]    || @send_timeout,
        :receive_timeout => opts[:receive_timeout] || @receive_timeout,
      })
    end

    def start
      super
    end

    def shutdown
      super
    end

    def format(tag, time, record)
      [tag, time, record].to_msgpack
    end

    def write(chunk)
      events = []
      chunk.msgpack_each do |tag, time, event|
        events << event
      end

      c = client()

      begin
        c.send(@target, events)
      rescue Alma::RPC::ClientError => e
        raise unless @drop_error_record
        log.warn "Alma server reports ClientError, and dropped", target: target, message: e.message
      rescue Alma::RPC::ServerError => e
        raise unless @drop_server_error_record
        log.warn "Alma server reports ServerError, and dropped", target: target, message: e.message
      rescue Alma::RPC::ServiceUnavailableError => e
        raise unless @drop_when_shutoff
        log.warn "Alma server is now in Shutoff mode, and dropped", target: target, message: e.message
      end
    end
  end
end
