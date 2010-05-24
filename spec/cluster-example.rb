require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))
require 'lib/cassandra_ruby/cluster'

shared_examples_for "initialized cluster" do
	it "should has inititially nil name" do
		@cluster.name.should == nil
	end
	
	it "should has inititially initialized endpoints array" do
		@cluster.endpoints.should_not == nil
	end
end

describe CassandraRuby::Cluster do
	
	before(:each) do
		@cluster = CassandraRuby::Cluster.new(addr)
		@cluster.should_not == nil
	end
	
	after(:each) do
		@cluster = nil
	end
	
	it_should_behave_like "initialized cluster"
	
	it "should connect to cassandra" do
		@cluster.connect
		@cluster.name.should == "Test Cluster"
		@cluster.endpoints.should == addr.to_a
	end
	
	it "should disconnect from cassandra" do
		@cluster.disconnect
		@cluster.name.should == nil
		@cluster.endpoints.should == addr.to_a
	end
	
	it "should make reconnect with cassandra" do
		@cluster.reconnect
		@cluster.name.should == "Test Cluster"
		@cluster.endpoints.should == addr.to_a
	end
	
	it "should fail if hasn't any endpoints" do
		@cluster.endpoints.clear
		pending("not fails for now") do
			raise 	
		end
	end
	
end
