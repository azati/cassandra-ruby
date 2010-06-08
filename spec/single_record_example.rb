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

describe CassandraRuby::SingleRecord do
  
  it_should_behave_like "initialized record"
  it_should_behave_like "fixtures loaded"
  
  before(:each) do
    @key = @data.keys.first
    @object = CassandraRuby::SingleRecord.new(@ks, @key)
  end
  
  it "#{described_class} should return 'key' value" do
    @object.key.should == @key
  end
  
  it "#{described_class} should implement 'get'" do
    result = @object.get('Standard1')
    result.empty?.should_not == true
    result.each do |c|
      c.class.should == CassandraRuby::Thrift::Column
    end
    
    result1 = @object.get('Super1')
    result1.empty?.should_not == true
    result1[0].class.should == CassandraRuby::Thrift::SuperColumn
    result1[0].name = 'SuperColumn'
    result1[0].columns.each do |c|
      c.class.should == CassandraRuby::Thrift::Column
    end
  end
  
  it "#{described_class} should implement 'insert'" do
    @object.insert('Standard1', nil, {'InsertTest1' => 'insert data 1', 'InsertTest2' => 'insert data 2'}, Time.now)
    result = @object.get('Standard1', nil, 'InsertTest1')
    result.class.should == CassandraRuby::Thrift::Column
    result.name.should == 'InsertTest1'
    
    @object.insert('Super1', 'InsertSuperColumn', {'InsertTest1' => 'insert data 1', 'InsertTest2' => 'insert data 2'}, Time.now)
    result = @object.get('Super1', 'InsertSuperColumn')
    result.class.should == CassandraRuby::Thrift::SuperColumn
    result.name.should == 'InsertSuperColumn'
    
    
    #Clean the storage. USE NATIVE THRIFT API ONLY!!!
    column_path = CassandraRuby::Thrift::ColumnPath.new(:column_family => 'Standard1',
        :super_column  => nil,
        :column        => 'InsertTest1'
    )
    time = Time.now
    time = time.to_i * 1_000_000 + time.usec
    @object.keyspace.client.remove(@object.keyspace.name, @key, column_path, time, CassandraRuby::Thrift::ConsistencyLevel::const_get(:one.to_s.upcase) )
    column_path = CassandraRuby::Thrift::ColumnPath.new(:column_family => 'Super1',
        :super_column  => 'InsertSuperColumn',
        :column        => nil
    )
    @object.keyspace.client.remove(@object.keyspace.name, @key, column_path, time, CassandraRuby::Thrift::ConsistencyLevel::const_get(:one.to_s.upcase) )
    
    #Verify if all was removed
    lambda{@object.get('Standard1', nil, 'InsertTest1')}.should raise_error(CassandraRuby::Thrift::NotFoundException)
    lambda{@object.get('Super1', 'InsertSuperColumn')}.should raise_error(CassandraRuby::Thrift::NotFoundException)
  end
  
  it "#{described_class} should implement 'remove'" do
    #Fill the storage. USE NATIVE THRIFT API ONLY!!!
    column_path = CassandraRuby::Thrift::ColumnPath.new(
        :column_family => 'Standard1',
        :super_column  => nil,
        :column        => 'RemoveTest1'
    )
    time = Time.now
    time = time.to_i * 1_000_000 + time.usec
    @object.keyspace.client.insert(@object.keyspace.name, @key, column_path, 'remove data 1', time, CassandraRuby::Thrift::ConsistencyLevel::const_get(:one.to_s.upcase))
    result = @object.get('Standard1', nil, 'RemoveTest1')
    result.class.should == CassandraRuby::Thrift::Column
    result.name.should == 'RemoveTest1'
    result.value.should == 'remove data 1'
    
    
    column_path = CassandraRuby::Thrift::ColumnPath.new(
        :column_family => 'Super1',
        :super_column  => 'RemoveSuperTest',
        :column        => 'column'
    )
    time = Time.now
    time = time.to_i * 1_000_000 + time.usec
    @object.keyspace.client.insert(@object.keyspace.name, @key, column_path, 'super remove data 1', time, CassandraRuby::Thrift::ConsistencyLevel::const_get(:one.to_s.upcase))
    result = @object.get('Super1', 'RemoveSuperTest')
    result.class.should == CassandraRuby::Thrift::SuperColumn
    result.name.should == 'RemoveSuperTest'
    result.columns[0].name.should == 'column'
    result.columns[0].value.should == 'super remove data 1'
    
    #Test itself
    @object.remove('Standard1', nil, 'RemoveTest1', Time.now)
    lambda{@object.get('Standard1', nil, 'RemoveTest1')}.should raise_error(CassandraRuby::Thrift::NotFoundException)
    
    @object.remove('Super1', 'RemoveSuperTest', nil, Time.now)
    lambda{@object.get('Super1', 'RemoveSuperTest')}.should raise_error(CassandraRuby::Thrift::NotFoundException)
  end
  
end