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

shared_examples_for "initialized cassandra" do
  it "Cluster should has inititially nil name" do
    @cassandra.cluster_name.should == nil
  end
  
  it "Cluster should has inititially initialized endpoints array" do
    @cassandra.endpoints.should_not == nil
  end
end

shared_examples_for "initialized keyspace" do
  it "Keyspace should have entry point" do
    @ks.client.should_not == nil
  end
  
  it "Keyspace should have the name" do
    @ks.name.should_not == nil
  end
end

shared_examples_for "prepared environment" do
  before(:all) do
    @cassandra = CassandraRuby::Cassandra.new(addr)
    @cassandra.should_not == nil
    
    @ks = CassandraRuby::Keyspace.new(@cassandra, 'Keyspace1')
  end
  
  after(:all) do
    @cassandra.disconnect
  end
  
  it_should_behave_like "initialized cassandra"
  it_should_behave_like "initialized keyspace"
end

shared_examples_for "initialized record" do
  it "Record should have keyspace" do
    @object.keyspace.should_not == nil
  end
  
  it_should_behave_like "thrift helper"
end

shared_examples_for "thrift helper" do
  
  it_should_behave_like "prepared environment"
  
  it "Record should have default options" do
    @object.send('default_options').should_not == nil
  end
  
  it "Record should cast time to millisecodns" do
    ts = Time.now
    @object.send('cast_timestamp', ts).should == ts.to_i * 1_000_000 + ts.usec
    lambda {@object.send('cast_timestamp', "wrong")}.should raise_error
  end
  
  it "Record should cast consistency" do
    @object.send('cast_consistancy', {}).should_not == nil
    @object.send('cast_consistancy', {}).should == CassandraRuby::Thrift::ConsistencyLevel::const_get(@object.default_options[:consistency].to_s.upcase)
  end
  
  it "Record should cast Thrift::SuperColumn or Thrift::Column (nothing else) to Thrift::ColumnOrSuperColumn." do
    sc = CassandraRuby::Thrift::SuperColumn.new
    c = CassandraRuby::Thrift::Column.new
    @object.send('cast_column_or_supercolumn', sc).class.should == CassandraRuby::Thrift::ColumnOrSuperColumn
    @object.send('cast_column_or_supercolumn', c).class.should == CassandraRuby::Thrift::ColumnOrSuperColumn
    lambda {@object.send('cast_column_or_supercolumn', String.new('test'))}.should raise_error(ArgumentError, "Column or SuperColumn should be provided")
  end
  
  it "Record should cast set of params to Thrift::Column" do
    @object.send('cast_column', "name", "value", Time.now).class.should == CassandraRuby::Thrift::Column
    lambda {@object.send('cast_column', "name", "value", "strange time")}.should raise_error
  end
  
  it "Record should cast set of params to Thrift::SuperColumn" do
    column = @object.send('cast_column', "name", "value", Time.now)
    @object.send('cast_super_column', "name", [column]).class.should == CassandraRuby::Thrift::SuperColumn
    @object.send('cast_super_column', "name", column).class.should == CassandraRuby::Thrift::SuperColumn
    @object.send('cast_super_column', "name", nil).class.should == CassandraRuby::Thrift::SuperColumn
    @object.send('cast_super_column', "name", "strange columns").class.should == CassandraRuby::Thrift::SuperColumn
  end
  
  it "Record should cast set of params to Thrift::ColumnPath" do
    column_family = 'Column Family'
    super_column = @object.send('cast_super_column', "name", "strange columns")
    column = @object.send('cast_column', "name", "value", Time.now)
    @object.send('cast_column_path', column_family, super_column, column).class.should == CassandraRuby::Thrift::ColumnPath
  end
  
  it "Record should cast set of params to Thrift::ColumnParent" do
    column_family = 'Column Family'
    super_column = @object.send('cast_super_column', "name", "strange columns")
    @object.send('cast_column_parent', column_family, super_column)
  end
  
  it "Record should cast set of params to Thrift::SlicePredicate" do
    column = @object.send('cast_column', "name", "value", Time.now)
    @object.send('cast_slice_predicate', [column], {}).class.should == CassandraRuby::Thrift::SlicePredicate
    @object.send('cast_slice_predicate', 1..5, {}).class.should == CassandraRuby::Thrift::SlicePredicate
    @object.send('cast_slice_predicate', '(st)range', {}).class.should == CassandraRuby::Thrift::SlicePredicate
    lambda {@object.send('cast_slice_predicate', column, {})}.should raise_error
    lambda {@object.send('cast_slice_predicate', nil, {})}.should raise_error(ArgumentError, 'columns can be String, Array or Range')
  end
  
  it "Record should cast set of params to Thrift::SliceRange" do
    column_range = '1'..'5'
    slice_range = @object.send('cast_slice_range', column_range, {})
    slice_range.class.should == CassandraRuby::Thrift::SliceRange
    slice_range.count.should == @object.default_options[:count]
    slice_range.reversed.should == @object.default_options[:reversed]
  end
  
  it "Record should cast set of params to Thrift::KeyRange" do
    column_range = '1'..'5'
    key_range = @object.send('cast_key_range', column_range, {})
    key_range.class.should == CassandraRuby::Thrift::KeyRange
    key_range.count.should == @object.default_options[:key_count]
  end
  
  it "Record should cast set of params to Thrift::Deletion" do
    super_column = @object.send('cast_super_column', "name", "strange columns")
    @object.send('cast_deletion', super_column, [], Time.now, {}).class.should == CassandraRuby::Thrift::Deletion
  end
  
  it "Record should cast set of params to Thrift::Mutation" do
    column = @object.send('cast_column', "name", "value", Time.now)
    mutation = @object.send('cast_mutation', column)
    mutation.class.should == CassandraRuby::Thrift::Mutation
    mutation.column_or_supercolumn.should == @object.send('cast_column_or_supercolumn', column) 
    
    super_column = @object.send('cast_super_column', "name", column)
    mutation = @object.send('cast_mutation', super_column)
    mutation.class.should == CassandraRuby::Thrift::Mutation
    mutation.column_or_supercolumn.should == @object.send('cast_column_or_supercolumn', super_column)
    
    deletion = @object.send('cast_deletion', super_column, [], Time.now, {})
    mutation = @object.send('cast_mutation', deletion)
    mutation.class.should == CassandraRuby::Thrift::Mutation
    mutation.deletion.should == deletion
    
    lambda{@object.send('cast_mutation', String.new)}.should raise_error(ArgumentError, 'Mutation should be a Column, SuperColumn or Deletion')
  end
end

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
