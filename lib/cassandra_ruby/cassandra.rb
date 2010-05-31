# Azati Cluster Framework
#
# Copyright (C) 2010  Azati Corporation (info@azati.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ----------------------------------------------------------------------------
# Authors:
#   Alexander Markelov
#

module CassandraRuby
  class Cassandra
    attr_reader :cluster_name, :endpoints

    def initialize(host_or_hosts, options = {})
      @port      = options[:port]      || 9160
      @transport = options[:transport] || ::Thrift::BufferedTransport
      @endpoints = host_or_hosts.is_a?(Array) ? host_or_hosts.dup : [host_or_hosts]
    end

    def connect
      cluster_safe_cycle do
        @cluster_name = @thrift_client.describe_cluster_name
        @endpoints    = describe_endpoints
      end
    end

    def disconnect
      @connection.close if @connection && @connection.open?
      @connection = nil
      @thrift_client = nil
    end

    def reconnect
      disconnect
      connect
    end

    Thrift::Client.instance_methods(false).each do |method|
      define_method(method) do |*args|
        cluster_safe_cycle { @thrift_client.send(method, *args) }
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
      @thrift_client = Thrift::Client.new(::Thrift::BinaryProtocol.new(@connection))
    rescue ::Thrift::TransportException
      disconnect
      raise
    else
      @thrift_client
    end

    def describe_endpoints
      @thrift_client.describe_keyspaces.inject([]) do |endpoints, keyspace|
        unless keyspace == 'system'
          endpoints |= describe_keyspace_endpoints(keyspace)
        end
        endpoints
      end
    end

    def describe_keyspace_endpoints(keyspace)
      @thrift_client.describe_ring(keyspace).inject([]) do |endpoints, token_range|
        endpoints |= token_range.endpoints
      end
    end
  end
end