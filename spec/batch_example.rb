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

describe CassandraRuby::Batch do
  
  before(:each) do
    @object = CassandraRuby::Batch.new(@ks)
  end
  
  it_should_behave_like "prepared environment"
  
  it "#{described_class} should implement '[]' method" do
    lambda {@object['']}.should_not raise_error
    @object[''].class.should == CassandraRuby::BatchRecord
  end
  
  it "#{described_class} should create mutation map" do
    record = @object['key1']
    @object.mutation_map.should == {"key1"=>{}}
  end
  
  it "#{described_class} should mutate" do
    @object.mutation_map.should == {}
    lambda {@object.mutate}.should_not raise_error
    
    batch_record = @object['key1']
    lambda {@object.mutate}.should_not raise_error
  end
  
end