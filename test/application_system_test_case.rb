require "test_helper"

require_relative "../helpers/url_helpers"
require "git_helpers"
require "middleman_helpers"

class ApplicationSystemTestCase < ActiveSupport::TestCase
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include UrlHelpers
  include GitHelpers
  include MiddlemanHelpers

  def around(&block)
    with_git_directory(&block)
  end

  def expand_history
    find("summary", text: "Expand History").click
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
