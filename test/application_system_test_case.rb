require "bundler"
Bundler.require(:default, :test)

require "minitest/autorun"
require "active_support"
require "active_support/test_case"

require "pathname"
require "tmpdir"

require "middleman/rack"

class ApplicationSystemTestCase < ActiveSupport::TestCase
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

      block.call Pathname(@repository.dir.path)
    end
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
