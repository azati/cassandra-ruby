require 'rubygems'
require '../lib/cassandra_ruby'

include CassandraRuby

cassandra = Cassandra.new('localhost')
begin
  cassandra.connect
  keyspace = Keyspace.new(cassandra, :Keyspace1)

  keyspace['a_key'].insert(:Standard1, nil, {'column_1' => 'value 1', 'column_2' => 'value 2'}, Time.now)
  puts keyspace['a_key'].get(:Standard1, nil, ''..'').inspect
  keyspace['a_key'].remove(:Standard1, nil, ['column_1', 'column_2'], Time.now)
  puts keyspace['a_key'].get(:Standard1, nil, ''..'').inspect

  
  keyspace['a_key'].insert(:Super1, 'super_column', {'column_1' => 'value 1', 'column_2' => 'value 2'}, Time.now)
  puts keyspace['a_key'].get(:Super1, 'super_column').inspect
  keyspace['a_key'].remove(:Super1, 'super_column', nil, Time.now)
  puts keyspace['a_key'].get(:Super1, 'super_column').inspect rescue CassandraRuby::Thrift::NotFoundException
ensure
  cassandra.disconnect
end