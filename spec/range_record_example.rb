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
    @object = CassandraRuby::RangeRecord.new(@ks, ''..'')
  end
  
  it_should_behave_like "initialized record"
  it_should_behave_like "fixtures loaded"
  
  it "#{described_class} should implement 'get'" do
    result = @object.get('Standard1')
    @data.each_key do |key| 
      result.has_key?(key).should == true
    end
    result.class.should == Hash 
  end
  
  it "#{described_class} should not implement 'insert'" do
    lambda {@object.insert(nil, nil, nil, nil, {})}.should raise_error(NotImplementedError)
  end
  
  it "#{described_class} should not implement 'remove'" do
    lambda {@object.remove(nil, nil, nil, nil, {})}.should raise_error(NotImplementedError)
  end
  
end