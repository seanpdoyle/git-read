require "bundler"

Bundler.require(:default, :test)

ENV["MODE"] ||= "build"

require "minitest/autorun"
require "middleman/rack"
require "active_support"
require "active_support/test_case"

Capybara.app = Middleman.server

class VisitorViewsReadmeTest < ActiveSupport::TestCase
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  test "visitor views README" do
    visit "/index.html"

    assert_selector "h1", text: "git-read"
  end
end
