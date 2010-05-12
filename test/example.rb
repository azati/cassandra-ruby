require 'rubygems'
require '../lib/cassandra_ruby'

transport    = Thrift::Socket.new('localhost', 9160)
#transport = Thrift::BufferedTransport.new(socket)
protocol  = Thrift::BinaryProtocol.new(transport)
cassandra = CassandraRuby::Thrift::Client.new(protocol)

def benchmark
  t = Time.now
  yield
  puts Time.now - t
end

transport.open
100.times do
  benchmark { cassandra.describe_ring('Keyspace1') }
end
transport.close