require "test_helper"
require "middleman/rack"
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

  def expand_history
    find("summary", text: "Expand History").click
  end

  def stage_file(filename, contents)
    Pathname(@repository.dir.path).join(filename).write(contents)

    @repository.add(filename)
  end

  def commit(message)
    @repository.commit(message)
  end

  def with_built_output(&block)
    git_directory = Pathname(@repository.dir.path)
    build_directory = git_directory.join("build")

    system <<~BASH, exception: true
      bin/git-read \
        --verbose \
        --git-dir #{git_directory} \
        --output-dir #{build_directory}
    BASH

    Capybara.app = Rack::Builder.new do
      use Rack::Static,
        urls: [""],
        root: build_directory,
        index: "index.html"

      run -> (*) {}
    end

    block.call
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
