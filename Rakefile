require 'rake'
require 'rubygems/package_task'
require 'rake/testtask'
require 'pp'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['./test/tc_*.rb']
  t.verbose = false
end

spec = eval(File.read('xml-smart.gemspec'))
Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
