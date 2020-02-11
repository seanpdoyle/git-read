module CommitHelpers
  mattr_accessor :repository

  def commit_path(commit)
    "/commits/#{commit.sha}/index.html"
  end

  def adjacent_commits(commit)
    log = [nil].chain(repository.log(nil).reverse_each).chain([nil])

    log.each_cons(3).detect { |_, middle, _| commit.sha == middle.sha }
  end
end
