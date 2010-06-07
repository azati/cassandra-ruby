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

describe CassandraRuby::Cassandra do
	
	before(:each) do
		@cassandra = CassandraRuby::Cassandra.new(addr)
		@cassandra.should_not == nil
	end
	
	after(:each) do
		@cassandra = nil
	end
	
	it_should_behave_like "initialized cassandra"
	
	it "#{described_class} should connect to cassandra" do
		@cassandra.connect
		@cassandra.cluster_name.should == "Test Cluster"
		@cassandra.endpoints.should == addr.to_a
	end
	
	it "#{described_class} should disconnect from cassandra" do
		@cassandra.disconnect
		@cassandra.cluster_name.should == nil
		@cassandra.endpoints.should == addr.to_a
	end
	
	it "#{described_class} should make reconnect with cassandra" do
		@cassandra.reconnect
		@cassandra.cluster_name.should == "Test Cluster"
		@cassandra.endpoints.should == addr.to_a
	end
	
	it "#{described_class} should fail if hasn't any endpoints" do
		@cassandra.endpoints.clear
    lambda {@cassandra.connect}.should raise_error(Thrift::TransportException)
	end
	
end
