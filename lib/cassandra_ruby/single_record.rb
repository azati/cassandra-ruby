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
  class SingleRecord < Record
    attr_reader :key

    def initialize(keyspace, key)
      super(keyspace)
      @key = key
    end

    def get(column_family, super_column, column = nil, options = {})
      if super_column.is_a?(Array) || super_column.is_a?(Range)
        super_column, column = nil, super_column
      elsif super_column.nil?
        column ||= ''..''
      end
      if column.nil? || column.is_a?(String)
        column = client.get(keyspace.name, key, cast_column_path(column_family, super_column, column), cast_consistancy(options))
        convert_column(column)
      else
        columns = client.get_slice(keyspace.name, key, cast_column_parent(column_family, super_column), cast_slice_predicate(column, options), cast_consistancy(options))
        convert_columns(columns)
      end
    end

    def insert(column_family, super_column, columns, time, options = {})
      if columns.size == 1
        client.insert(keyspace.name, key, cast_column_path(column_family, super_column, columns.keys.first), columns.values.first, cast_timestamp(time), cast_consistancy(options))
      else
        keyspace.batch(options) do |batch|
          batch[key].insert(column_family, super_column, columns, time, options)
        end
      end
    end

    def remove(column_family, super_column, column, time, options = {})
      if super_column.is_a?(Array) || super_column.is_a?(Range)
        super_column, column = nil, super_column
      end
      if column.is_a?(NilClass) || column.is_a?(String)
        client.remove(keyspace.name, key, cast_column_path(column_family, super_column, column), cast_timestamp(time), cast_consistancy(options))
      else
        keyspace.batch(options) do |batch|
          batch[key].remove(column_family, super_column, column, time, options)
        end
      end
    end
  end
end