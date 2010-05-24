require "rubygems"
require 'lib/cassandra_ruby'
require "spec"
require 'socket'

def addr 
	@addr = @addr || Socket::getaddrinfo(Socket.gethostname, "echo", Socket::AF_INET)[0][3]
	@addr
end

def addr=(addr)
	@addr = addr
end

