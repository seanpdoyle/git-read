class History
  attr_reader :readme, :repository

  def initialize(readme:, repository:)
    @readme = readme
    @repository = repository
  end

  def initial_commit
    commits.first
  end

  def commits
    repository.log(nil).reverse_each
  end
end
