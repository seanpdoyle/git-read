require "bundler"

Bundler.require(:default, :test)

ENV["MODE"] ||= "build"

require "minitest/autorun"
require "middleman/rack"
require "active_support"
require "active_support/test_case"
require "pathname"
require "tmpdir"


require_relative "../helpers/url_helpers"

class ApplicationSystemTestCase < ActiveSupport::TestCase
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include UrlHelpers

  def around(&block)
    directory = Dir.mktmpdir
    begin
      @repository = Git.init(directory)
      block.call
    ensure
      FileUtils.rm_rf(directory)
    end
  end

  def stage_file(filename, contents)
    Pathname(@repository.dir.path).join(filename).write(contents)

    @repository.add(filename)
  end

  def commit(message)
    @repository.commit(message)
  end

  def with_git_repository(&block)
    ClimateControl.modify(GIT_DIR: @repository.dir.path) do
      Capybara.app = Middleman.server

      block.call Pathname(@repository.dir.path)
    end
  end

  def expand_history
    find("details > summary", text: "Expand History").click
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
