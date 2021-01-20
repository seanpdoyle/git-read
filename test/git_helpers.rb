require "middleman/rack"
require "pathname"
require "tmpdir"

module GitHelpers
  def stage_file(filename, contents)
    filepath = Pathname(@repository.dir.path).join(filename)

    filepath.dirname.mkpath

    filepath.write(contents)

    @repository.add(filename)
  end

  def commit(message)
    @repository.commit(message)

    @repository.object("HEAD")
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

  def with_git_directory(&block)
    directory = Dir.mktmpdir
    @repository = Git.init(directory)
    block.call
  ensure
    FileUtils.rm_rf(directory)
  end

  def switch_branch(branch_name, from: main_branch, &block)
    branch = @repository.branch(branch_name)

    branch.checkout

    block.call(branch).tap { branch.gcommit }
  ensure
    from.checkout
  end

  def main_branch
    @repository.branches[:main]
  end

  def tag_head_commit(tag_name)
    @repository.add_tag(tag_name)
  end
end
