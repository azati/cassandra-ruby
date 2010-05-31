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
require 'lib/cassandra_ruby/record'

shared_examples_for "initialized-record" do
  it "should have keyspace" do
    @record.keyspace.should_not == nil
  end
end

describe CassandraRuby::Record do
  
  before(:each) do
    @cassandra = CassandraRuby::Cassandra.new(addr)
    @cassandra.should_not == nil
    
    @ks = CassandraRuby::Keyspace.new(@cassandra, 'Keyspace1')
    
    @record = CassandraRuby::Record.new(@ks)
  end
  
  after(:all) do
    @cassandra.disconnect
  end
  
  it_should_behave_like "initialized-record"
end
