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
#   Artem Zakolodkin
#

require "rubygems"
require 'lib/cassandra_ruby'
require "spec"

def addr 
  @addr = @addr || local_ip
  @addr
end

def addr=(addr)
  @addr = addr
end

private 

def local_ip
  ifconfig = %x(which /sbin/ifconfig).strip
  %x(ifconfig).split("lo").shift =~ /inet addr\:(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s/
  $1
end
