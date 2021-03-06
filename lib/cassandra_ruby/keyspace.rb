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
  
  # Main class to communicate with CassandraDB.
  class Keyspace
    
    # returns instance of Cassandra 
    attr_reader :client
    
    # returns name of the Keyspace
    attr_reader :name

    # * <tt>client</tt> - instance of Cassandra
    # * <tt>name</tt> - name of the keyspace described in <tt>storage-conf.xml</tt>
    def initialize(client, name)
      @client, @name = client, name.to_s
    end

    # Accessor to the Record functionality.
    # * <tt>key</tt> - name of the only key in the db
    # * <tt>keys</tt> - to define set of keys
    # Set of params defines the implementation of Record
    # (SingleRecord, MultiRecord, RangeRecord) returned.
    #
    #   Keyspace['key1'] => # SingleRecord.new
    #   Keyspace[['key1', 'key2']] => # MultiRecord.new
    #   Keyspace['key1'..'key3'] => # RangeRecord.new
    #
    # Examples
    #   keyspace['a_key'].insert(:Standard1, nil, {'column_1' => 'value 1', 'column_2' => 'value 2'}, Time.now)
    #   keyspace['a_key'].remove(:Standard1, nil, ['column_1', 'column_2'], Time.now)
    #  
    def [](key, *keys)
      keys = keys.empty? ? key : [key] + keys

      record_type = case keys
      when String
        SingleRecord
      when Array
        MultiRecord
      when Range
        RangeRecord
      end

      record_type.new(self, keys)
    end

    def batch(options = {})
      batch = Batch.new(self)
      yield(batch)
      batch.mutate(options)
    end
  end
end