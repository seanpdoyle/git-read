module CommitHelpers
  def commit?
    current_commit.present?
  end

  def current?(commit)
    [
      current_commit.id,
      commit,
    ].map(&:to_s).uniq.size == 1
  end

  def first_commit_sha
    data.history.commits.first
  end

  def current_commit
    sha = current_page.data.id || yield_content(:id)

    data.commits[sha]
  end

  def commit_path(commit)
    "/commits/#{commit}/"
  end
end
