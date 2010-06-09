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

describe CassandraRuby::MultiRecord do
  
  it_should_behave_like "initialized record"
  it_should_behave_like "fixtures loaded"
  
  before(:each) do
    @keys = [@data.keys.first, @data.keys.last] 
    @object = CassandraRuby::MultiRecord.new(@ks, @keys)
  end
  
  it "#{described_class} should return 'keys' value" do
    @object.keys.should == @keys
  end
  
  it "#{described_class} should implement 'get'" do
    result = @object.get('Standard1')
    result.empty?.should_not == true
    result.each do |c|
      @data.keys.include?(c[0]).should == true
      c[1].class.should == Array
      c[1].each do |item|
        item.class.should == CassandraRuby::Thrift::Column
      end
    end
    
    result = @object.get('Super1')
    result.empty?.should_not == true
    result.each do |c|
      @data.keys.include?(c[0]).should == true
      c[1].class.should == Array
      c[1].each do |item|
        item.class.should == CassandraRuby::Thrift::SuperColumn
      end
    end
  end
  
  it "#{described_class} should implement 'insert'" do
    @object.insert('Standard1', nil, {'InsertTest1'=>'aaa'}, Time.now)
    result = @object.get('Standard1', nil, 'InsertTest1')
    result.keys.count.should == @keys.count
    result.each do |key, data|
      @keys.include?(key).should == true
      data.class.should == CassandraRuby::Thrift::Column
      data.name.should == 'InsertTest1'
    end
    
    @object.insert('Super1', 'InsertSuperColumn', {'InsertTest1' => 'insert data 1'}, Time.now)
    result = @object.get('Super1', 'InsertSuperColumn')
    result.keys.count.should == @keys.count
    result.each do |key, data|
      @keys.include?(key).should == true
      data.class.should == CassandraRuby::Thrift::SuperColumn
      data.name.should == 'InsertSuperColumn'
    end
    
    
    #Clean the storage. USE NATIVE THRIFT API ONLY!!!
    column_path = CassandraRuby::Thrift::ColumnPath.new(:column_family => 'Standard1',
        :super_column  => nil,
        :column        => 'InsertTest1'
    )
    time = Time.now
    time = time.to_i * 1_000_000 + time.usec
    @keys.each do |key|
      @object.keyspace.client.remove(@object.keyspace.name, key, column_path, time, CassandraRuby::Thrift::ConsistencyLevel::const_get(:one.to_s.upcase) )  
    end
    
    column_path = CassandraRuby::Thrift::ColumnPath.new(:column_family => 'Super1',
        :super_column  => 'InsertSuperColumn',
        :column        => nil
    )
    @keys.each do |key|
      @object.keyspace.client.remove(@object.keyspace.name, key, column_path, time, CassandraRuby::Thrift::ConsistencyLevel::const_get(:one.to_s.upcase) )
    end
    #Verify if all was removed
    result = @object.get('Standard1', nil, 'InsertTest1')
    @keys.each do |key|
      result[key].should == nil  
    end
    
    result = @object.get('Super1', 'InsertSuperColumn')
    @keys.each do |key|
      result[key].should == nil
    end
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
    @keys.each do |key|
      @object.keyspace.client.insert(@object.keyspace.name, key, column_path, 'remove data 1', time, CassandraRuby::Thrift::ConsistencyLevel::const_get(:one.to_s.upcase))
    end
    
    column_path = CassandraRuby::Thrift::ColumnPath.new(
        :column_family => 'Super1',
        :super_column  => 'RemoveSuperTest',
        :column        => 'column'
    )
    time = Time.now
    time = time.to_i * 1_000_000 + time.usec
    @keys.each do |key|
      @object.keyspace.client.insert(@object.keyspace.name, key, column_path, 'super remove data 1', time, CassandraRuby::Thrift::ConsistencyLevel::const_get(:one.to_s.upcase))  
    end
    
    #Test itself
    @object.remove('Standard1', nil, 'RemoveTest1', Time.now)
    result = @object.get('Standard1', nil, 'RemoveTest1')
    @keys.each do |key|
      result[key].should == nil
    end
    
    @object.remove('Super1', 'RemoveSuperTest', 'column', Time.now)
    result = @object.get('Super1', 'RemoveSuperTest')
    @keys.each do |key|
      result[key].should == nil
    end
  end
  
end