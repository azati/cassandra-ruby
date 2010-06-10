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

describe CassandraRuby::BatchRecord do
  
  before(:each) do
    @object = CassandraRuby::BatchRecord.new(@ks)
  end
  
  it_should_behave_like "initialized record"
  
  it "#{described_class} should not implement 'get'" do
    lambda {@object.get(nil, nil, nil, {})}.should raise_error(NotImplementedError)
  end
  
  it "#{described_class} should implement 'insert'" do
    @object.insert('Standard1', nil, ['Column1', 'Column2'], Time.now)
    @object.mutation_map['Standard1'].should_not == nil
    @object.mutation_map['Standard1'].size.should == 2
    
    @object.insert('Super1', 'Super', ['Column1', 'Column2'], Time.now)
    @object.mutation_map['Super1'].should_not == nil
    @object.mutation_map['Super1'].each do |m|
      m.class.should == CassandraRuby::Thrift::Mutation
      m.column_or_supercolumn.class.should == CassandraRuby::Thrift::ColumnOrSuperColumn
      m.column_or_supercolumn.super_column.columns.each do |c|
        c.class.should == CassandraRuby::Thrift::Column
      end
    end
     
    @object.mutation_map['Super1'].size.should == 1
  end
  
  it "#{described_class} should implement 'remove'" do
    @object.remove('Standard1', nil, ['Column1', 'Column2'], Time.now)
    @object.mutation_map['Standard1'].should_not == nil
  end
  
end
