require "bundler"

Bundler.require(:default, :test)

ENV["MODE"] ||= "build"

require "minitest/autorun"
require "middleman/rack"
require "active_support"
require "active_support/test_case"
require "pathname"
require "tmpdir"


class VisitorViewsReadmeTest < ActiveSupport::TestCase
  include Capybara::DSL
  include Capybara::Minitest::Assertions

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

      block.call
    end
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  test "visitor views README" do
    stage_file("README.md", <<~MARKDOWN)
    git-read
    ===

    Hello, from tests!
    MARKDOWN
    commit("Initial Commit")

    with_git_repository do
      visit "/index.html"

      assert_title "git-read"
      assert_selector "h1", text: "git-read"
      assert_selector "p", text: "Hello, from tests!"
    end
  end
end
