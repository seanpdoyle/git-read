ENV["RACK_ENV"] = "test"

Bundler.require(:default, :test)

require "middleman/rack"
require "active_support"
require "active_support/test_case"
require "active_support/testing/autorun"

class VisitorViewsRootTest < ActiveSupport::TestCase
  include Capybara::DSL

  setup do
    Capybara.app = Middleman.server.to_app
  end

  test "visitor views root" do
    visit "/index.html"

    assert_text "git-read"
  end
end
