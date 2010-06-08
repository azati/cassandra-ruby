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

describe CassandraRuby::RangeRecord do
  before(:each) do
    @object = CassandraRuby::RangeRecord.new(@ks, 'key1'..'key3')
    record = CassandraRuby::SingleRecord.new(@ks, 'key1')
    record.insert('Standard1', nil, {'Column1' => 'data1'}, Time.now)
    record = CassandraRuby::SingleRecord.new(@ks, 'key2')
    record.insert('Standard1', nil, {'Column1' => 'data2'}, Time.now)
    record = CassandraRuby::SingleRecord.new(@ks, 'key3')
    record.insert('Standard1', nil, {'Column1' => 'data3'}, Time.now)
  end
  
  it_should_behave_like "initialized record"
  
  it "#{described_class} should implement 'get'" do
    puts @object.get('Standard1').inspect
  end
  
  it "#{described_class} should not implement 'insert'" do
    lambda {@object.insert(nil, super_column = nil, column = nil, time = nil, options = {})}.should raise_error(NotImplementedError)
  end
  
  it "#{described_class} should not implement 'remove'" do
    lambda {@object.remove(nil, super_column = nil, column = nil, time = nil, options = {})}.should raise_error(NotImplementedError)
  end
  
end