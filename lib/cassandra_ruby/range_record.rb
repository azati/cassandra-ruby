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
  class RangeRecord < Record
    attr_reader :key_range
    
    def initialize(keyspace, key_range)
      super(keyspace)
      @key_range = key_range
    end
    
    def get(column_family, super_column = nil, column = nil, options = {})
      if column.nil? || super_column.is_a?(Array) || super_column.is_a?(Range)
        super_column, column = nil, super_column
        column = ''..'' if column.nil?
      end
      
      key_slices = client.get_range_slices(keyspace.name, cast_column_parent(column_family, super_column), cast_slice_predicate(column, options), cast_key_range(key_range, options), cast_consistancy(options))
      
      if column.is_a?(String)
        key_slices.inject({}){ |h, s| h[s.key] = s.columns.first && convert_column(s.columns.first) ; h }
      else
        key_slices.inject({}){ |h, s| h[s.key] = convert_columns(s.columns) ; h }
      end
    end
  end
end