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
require 'lib/cassandra_ruby/cassandra'

shared_examples_for "initialized cassandra" do
	it "should has inititially nil name" do
		@cassandra.cluster_name.should == nil
	end
	
	it "should has inititially initialized endpoints array" do
		@cassandra.endpoints.should_not == nil
	end
end

describe CassandraRuby::Cassandra do
	
	before(:each) do
		@cassandra = CassandraRuby::Cassandra.new(addr)
		@cassandra.should_not == nil
	end
	
	after(:each) do
		@cassandra = nil
	end
	
	it_should_behave_like "initialized cassandra"
	
	it "should connect to cassandra" do
		@cassandra.connect
		@cassandra.cluster_name.should == "Test Cluster"
		@cassandra.endpoints.should == addr.to_a
	end
	
	it "should disconnect from cassandra" do
		@cassandra.disconnect
		@cassandra.cluster_name.should == nil
		@cassandra.endpoints.should == addr.to_a
	end
	
	it "should make reconnect with cassandra" do
		@cassandra.reconnect
		@cassandra.cluster_name.should == "Test Cluster"
		@cassandra.endpoints.should == addr.to_a
	end
	
	it "should fail if hasn't any endpoints" do
		@cassandra.endpoints.clear
		pending("not fails for now") do
			raise 	
		end
	end
	
end
