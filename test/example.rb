require 'rubygems'
require '../lib/cassandra_ruby'

cassandra = CassandraRuby::Cluster.new('192.168.92.198')
cassandra.connect
# 5.times { |i| puts 5 - i; sleep(1) }
cassandra.describe_ring('Keyspace1').each { |i| puts i.inspect }
puts cassandra.endpoints
cassandra.disconnect