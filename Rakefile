require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

spec = Gem::Specification.new do |s|
  s.name = 'cassandra-ruby'
  s.version = '0.1.1a'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.requirements = 'thrift, Cassandra 0.6 or higher'
  s.add_dependency('thrift', '>= 0.2.0.4')
  s.homepage = 'http://github.com/azati/cassandra-ruby'
  s.summary = 'cassandra-ruby is a lightweight and clean Ruby client for the Cassandra distributed database. '
  s.description = s.summary
  s.author = 'Azati'
  s.email = 'info@azati.com'
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "cassandra-ruby Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end
