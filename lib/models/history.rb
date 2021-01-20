require "lib/models/commit"

class History
  attr_reader :name, :readme, :repository, :root

  def initialize(name:, readme:, repository:, root:, out_of_date: false)
    @name = name
    @readme = readme
    @repository = repository
    @root = root
    @out_of_date = out_of_date
  end

  def initial_commit
    commits.first
  end

  def commits
    root.log(nil).reverse_each.map do |commit|
      Commit.new(commit: commit, repository: repository)
    end
  end

  def out_of_date?
    @out_of_date
  end
end
