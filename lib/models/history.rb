class History
  attr_reader :name, :readme, :repository

  def initialize(name:, readme:, repository:)
    @name = name
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
