class History
  attr_reader :readme, :repository, :root

  def initialize(readme:, repository:, root:, out_of_date: false)
    @readme = readme
    @root = root
    @repository = repository
    @out_of_date = out_of_date
  end

  def out_of_date?
    @out_of_date
  end

  def name
    File.basename(repository.dir.path)
  end

  def initial_commit
    commits.reject(&:skip?).first || commits.first
  end

  def commits
    root.log(nil).reverse_each.map do |commit|
      Commit.new(
        commit: commit,
        repository: repository,
      )
    end
  end
end
