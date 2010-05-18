require 'rubygems'
require '../lib/cassandra_ruby'

class MyCluster < CassandraRuby::Cluster
  include CassandraRuby::ApiWrapper
end

def benchmark(times)
  t = Time.now
  times.times { |i| yield(i) }
  puts Time.now - t
end

cassandra = MyCluster.new('192.168.92.198')
begin

  r = cassandra.get_range_slices(:Keyspace1, 'Standard1', CassandraRuby::ApiWrapper::DEFAULT_COLUMNS_OR_RANGE, :start_key => '', :end_key => '', :count => 10000)
  batch = r.inject({}) do |b,record|
    b[record.keys.first] = {
      'Standard1' => [
        { :delete => record.values.first.map{ |c| c.name }, :timestamp => Time.now.to_i * 2_000_000 }
      ]
    }
    b
  end

  puts r

  # cassandra.batch_mutate(:Keyspace1, batch)

  # cassandra.insert(:Keyspace1, 'bla-bla', ['Standard1', 'column_bla'], '123', Time.now.to_i * 1_000_000)
  # cassandra.remove(:Keyspace1, 'bla-bla', ['Standard1', 'column_bla'], Time.now.to_i * 1_000_000)
  # cassandra.batch_mutate(:Keyspace1, { 'bla-bla' => { 'Standard1' => [:delete => ['column_bla'], :timestamp => Time.now.to_i * 1_000_000] }})
  puts cassandra.get(:Keyspace1, 'bla-bla', ['Standard1', 'column_bla']).inspect
ensure
  cassandra.disconnect
end