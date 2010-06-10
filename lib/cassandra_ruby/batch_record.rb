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
  
  # Class is used in Batch class to perform batch operations - insert and remove
  class BatchRecord < Record
    
    # Returns the following structure:
    # {"column_family1" => [array of columns], "column_family2" => [array of columns], ...}
    attr_reader :mutation_map
    
    # <tt>keyspace</tt> - instance of Keyspace
    def initialize(keyspace)
      super(keyspace)
      @mutation_map = Hash.new { |hash, key| hash[key] = [] }
    end
    
    # Returns mutation map for batch insert operation
    # * <tt>column_family</tt> - name of the column family. 
    # * <tt>super_column</tt> - name of the super column
    # * <tt>columns</tt> - array or hash of columns
    # * <tt>time</tt> - timestamp
    #
    # Examples
    #   BatchRecord.insert(:Keyspace1, nil, ['Column1', 'Column2'], Time.now)
    #   BatchRecord.insert('Standard1', nil, {'Column1' => 'value1', 'Column2' => 'value2'}, Time.now)
    #   BatchRecord.insert(:Super1, 'Super', ['Column1', 'Column2'], Time.now)
    #   BatchRecord.insert('Super1', 'Super', {'Column1' => 'value1', 'Column2' => 'value2'}, Time.now)
    #
    # See also: Mutation[http://wiki.apache.org/cassandra/API#Mutation]
    def insert(column_family, super_column, columns, time)
      insertions = columns.map { |name, value| cast_column(name, value, time) }
      insertions = [cast_super_column(super_column, insertions)] if super_column
      insertions.map! { |i| cast_mutation(i) }
      @mutation_map[column_family.to_s].concat(insertions)
    end
    
    # Returns mutation map for batch remove operation
    # * <tt>column_family</tt> - name of the column family. 
    # * <tt>super_column</tt> - name of the super column
    # * <tt>columns</tt> - array or hash of columns
    # * <tt>time</tt> - timestamp
    #
    # Examples
    #   BatchRecord.remove(:Keyspace1, nil, ['Column1', 'Column2'], Time.now)
    #   BatchRecord.remove('Standard1', nil, {'Column1' => 'value1', 'Column2' => 'value2'}, Time.now)
    #   BatchRecord.remove(:Super1, 'Super', ['Column1', 'Column2'], Time.now)
    #   BatchRecord.remove('Super1', 'Super', {'Column1' => 'value1', 'Column2' => 'value2'}, Time.now)
    #
    # See also: Mutation[http://wiki.apache.org/cassandra/API#Mutation]
    def remove(column_family, super_column, columns, time, options = {})
      deletion = cast_deletion(super_column, columns, time, options)
      deletion = cast_mutation(deletion)
      @mutation_map[column_family.to_s] << deletion
    end
  end
end