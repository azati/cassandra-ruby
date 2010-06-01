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
  module ThriftHelper

    def default_options
      @default_cast_options ||= {
        :consistency => :one,
        :count       => 100,
        :key_count   => 100,
        :reversed    => false,
      }
    end

    protected

    def cast_consistancy(options)
      consistency = options[:consistency] || default_options[:consistency]
      Thrift::ConsistencyLevel::const_get(consistency.to_s.upcase)
    end

    def cast_timestamp(time)
      time.to_i * 1_000_000 + time.usec
    end

    def cast_column_or_supercolumn(column)
      params = case column
      when Thrift::Column
        { :column => column }
      when Thrift::SuperColumn
        { :super_column => column }
      else
        raise ArgumentError.new('Column or SuperColumn should be provided')
      end

      Thrift::ColumnOrSuperColumn.new(params)
    end

    def cast_column(name, value, time)
      Thrift::Column.new(
        :name => name,
        :value => value,
        :timestamp => cast_timestamp(time)
      )
    end

    def cast_super_column(name, columns)
      Thrift::SuperColumn.new(
        :name => name,
        :columns => columns
      )
    end

    def cast_column_path(column_family, super_column, column)
      Thrift::ColumnPath.new(
        :column_family => column_family.to_s,
        :super_column  => super_column,
        :column        => column
      )
    end

    def cast_column_parent(column_family, super_column)
      Thrift::ColumnParent.new(
        :column_family => column_family.to_s,
        :super_column  => super_column
      )
    end

    def cast_slice_predicate(columns, options)
      params = case columns
      when String, Array
        { :column_names => Array(columns) }
      when Range
        { :slice_range => cast_slice_range(columns, options) }
      else
        raise ArgumentError.new('columns can be Range or Array')
      end
      Thrift::SlicePredicate.new(params)
    end

    def cast_slice_range(column_range, options)
      Thrift::SliceRange.new(
        :start    => column_range.first,
        :finish   => column_range.last,
        :count    => options[:count] || default_options[:count],
        :reversed => options[:reversed] || default_options[:reversed]
      )
    end

    def cast_key_range(key_range, options)
      Thrift::KeyRange.new(
        :start_key   => key_range.first,
        :end_key     => key_range.last,
        :start_token => options[:start_token],
        :end_token   => options[:end_token],
        :count       => options[:key_count] || default_options[:key_count]
      )
    end

    def cast_mutation(column_or_deletion)
      params = case column_or_deletion
      when Thrift::Column, Thrift::SuperColumn
        { :column_or_supercolumn => cast_column_or_supercolumn(column_or_deletion) }
      when Thrift::Deletion
        { :deletion => column_or_deletion }
      else
        raise ArgumentError.new('Mutation should be a Column, SuperColumn or Deletion')
      end
      Thrift::Mutation.new(params)
    end

    def cast_deletion(super_column, columns, time, options)
      Thrift::Deletion.new(
        :timestamp    => cast_timestamp(time),
        :super_column => super_column,
        :predicate    => cast_slice_predicate(columns, options)
      )
    end

    def cast_authentication_request(credentials)
      AuthenticationRequest.new(:credentials => credentials)
    end

    def convert_column(column)
      column.super_column || column.column
    end

    def convert_columns(column_list)
      column_list.map { |c| convert_column(c) }
    end
  end
end