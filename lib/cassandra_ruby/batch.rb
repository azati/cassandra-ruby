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
  class Batch
    include ThriftHelper

    attr_reader :keyspace

    def initialize(keyspace)
      @keyspace = keyspace
      @records = {}
    end

    def [](key)
      @records[key] ||= BatchRecord.new(keyspace)
    end

    def mutate(options = {})
      keyspace.client.batch_mutate(keyspace.name, mutation_map, cast_consistancy(options))
    end

    def mutation_map
      @records.inject({}) do |memo, (key, record)|
        memo[key] = record.mutation_map
        memo
      end
    end
  end
end