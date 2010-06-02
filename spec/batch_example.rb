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

require File.expand_path(File.join('.', 'helpers', 'spec_helper'), File.dirname(__FILE__))
require 'lib/cassandra_ruby/batch'



describe CassandraRuby::Batch do
  
  before(:all) do
    @cassandra = CassandraRuby::Cassandra.new(addr)
    @cassandra.should_not == nil
    
    @ks = CassandraRuby::Keyspace.new(@cassandra, 'Keyspace1')
  end
  
  before(:each) do
    @object = CassandraRuby::Batch.new(@ks)
  end
  
  after(:all) do
    @cassandra.disconnect
  end
  
  it "#{described_class} should implement '[]' method" do
    lambda {@object['']}.should_not raise_error
    @object[''].class.should == CassandraRuby::BatchRecord
  end
  
  it "#{described_class} should create mutation map" do
    @object['key1']
    @object['key2']
    @object['key3']
  end
  
  it "#{described_class} should mutate" do
    pending("not implemented") do
      raise   
    end    
  end
  
end