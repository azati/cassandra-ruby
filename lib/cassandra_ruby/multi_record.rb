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
  class MultiRecord < Record
    attr_reader :keys

    def initialize(keyspace, keys)
      super(keyspace)
      @keys = keys
    end

    def get(column_family, super_column = nil, column = nil, options = {})
      if column.nil? || super_column.is_a?(Array) || super_column.is_a?(Range)
        super_column, column = nil, super_column
        column = ''..'' if column.nil?
      end

      key_columns = client.multiget_slice(keyspace.name, keys, cast_column_parent(column_family, super_column), cast_slice_predicate(column, options), cast_consistancy(options))

      if column.is_a?(String)
        key_columns.each { |key, columns| key_columns[key] = columns.first && convert_column(columns.first) }
      else
        key_columns.each { |key, columns| key_columns[key] = convert_columns(columns) }
      end
    end

    def insert(column_family, super_column, columns, time, options = {})
      keyspace.batch(options) do |batch|
        keys.each do |k|
          batch[k].insert(column_family, super_column, columns, time, options)
        end
      end
    end

    def remove(column_family, super_column, column, time, options = {})
      keyspace.batch(options) do |batch|
        keys.each do |k|
          batch[k].remove(column_family, super_column, column, time, options)
        end
      end
    end
  end
end