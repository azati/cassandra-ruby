module CassandraRuby
  class Cluster
    attr_reader :name, :endpoints

    def initialize(host_or_hosts, options = {})
      @port      = options[:port]      || 9160
      @transport = options[:transport] || ::Thrift::BufferedTransport

      @endpoints = host_or_hosts.is_a?(Array) ? host_or_hosts.dup : [host_or_hosts]
    end

    def connect
      cluster_safe_cycle do
        @name      = @client.describe_cluster_name
        @endpoints = describe_endpoints
      end
    end

    def disconnect
      @connection.close if @connection && @connection.open?
      @connection = nil
      @client     = nil
    end

    def reconnect
      disconnect
      connect
    end

    Thrift::Client.instance_methods(false).each do |method|
      define_method(method) do |*args|
        cluster_safe_cycle { @client.send(method, *args) }
      end
    end

    protected

    def cluster_safe_cycle
      connect_to(@endpoints.first) unless @connection && @connection.open?
      result = yield
    rescue ::Thrift::TransportException
      disconnect
      @endpoints.shift
      raise if @endpoints.empty?
      retry
    else
      result
    end

    def connect_to(host)
      @connection = ::Thrift::Socket.new(host, @port)
      @connection = @transport.new(@connection)
      @connection.open
      @client = Thrift::Client.new(::Thrift::BinaryProtocol.new(@connection))
    rescue ::Thrift::TransportException
      disconnect
      raise
    else
      @client
    end

    def describe_endpoints
      @client.describe_keyspaces.inject([]) do |endpoints, keyspace|
        unless keyspace == 'system'
          endpoints |= describe_keyspace_endpoints(keyspace)
        end
        endpoints
      end
    end

    def describe_keyspace_endpoints(keyspace)
      @client.describe_ring(keyspace).inject([]) do |endpoints, token_range|
        endpoints |= token_range.endpoints
      end
    end
  end
end