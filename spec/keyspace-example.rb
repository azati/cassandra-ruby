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

require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'lib/cassandra_ruby/keyspace'

shared_examples_for "initialized-keyspace" do
  it "should have entry point" do
    @ks.client.should_not == nil
  end
  
  it "should have the name" do
    @ks.name.should_not == nil
  end
  
end

describe CassandraRuby::Keyspace do
  
  before(:all) do
    @cassandra = CassandraRuby::Cassandra.new(addr)
    @cassandra.should_not == nil
    
    @ks = CassandraRuby::Keyspace.new(@cassandra, 'Keyspace1')
  end
  
  after(:all) do
    @cassandra.disconnect
  end
  
  it_should_behave_like "initialized cassandra"
  it_should_behave_like "initialized-keyspace"
  
  
end
