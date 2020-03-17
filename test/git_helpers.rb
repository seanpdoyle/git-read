require "pathname"
require "tmpdir"

require "middleman/rack"

module GitHelpers
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

  def with_git_directory(&block)
    directory = Dir.mktmpdir
    begin
      @repository = Git.init(directory)
      block.call
    ensure
      FileUtils.rm_rf(directory)
    end
  end
end
