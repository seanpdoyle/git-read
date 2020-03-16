require "rake/testtask"

Rake::TestTask.new do |test|
  test.libs << "test"
  test.pattern = "test/**/*_test.rb"
  test.verbose = true
  test.ruby_opts = ["-W0"]
end

task default: :test
