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
  class Record
    include ThriftHelper

    attr_reader :keyspace

    def initialize(keyspace)
      @keyspace = keyspace
    end

    def get(column_family, super_column = nil, column = nil, options = {})
      raise NotImplementedError
    end

    def insert(column_family, super_column, columns, time, options = {})
      raise NotImplementedError
    end

    def remove(column_family, super_column, column, time, options = {})
      raise NotImplementedError
    end

    protected

    def client
      keyspace.client
    end
  end
end