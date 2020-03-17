require "bundler"

Bundler.require(:default, :test)

ENV["MODE"] ||= "build"

require "minitest/autorun"
require "active_support"
require "active_support/test_case"
