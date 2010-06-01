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
require 'lib/cassandra_ruby/thrift_helper'

class Dummy
  include CassandraRuby::ThriftHelper
  
  def ts(ts)
    self.cast_timestamp(ts)
  end
  
  def consistancy(c = {})
    self.cast_consistancy(c)
  end
end

describe CassandraRuby::ThriftHelper do
  
  before(:all) do
    @helper = Dummy.new
  end
  
  it "should have default options" do
    @helper.default_options.should_not == nil
  end
  
  it "should cast time to millisecodns" do
    ts = Time.now
    @helper.ts(ts).should == ts.to_i * 1_000_000 + ts.usec
  end
  
  it "should ensure consistency" do
    @helper.consistancy.should_not == nil
    @helper.consistancy.should == CassandraRuby::Thrift::ConsistencyLevel::const_get(@helper.default_options[:consistency].to_s.upcase)
  end
end