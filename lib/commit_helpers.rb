module CommitHelpers
  def commit_path(commit)
    "/commits/#{commit.sha}/"
  end
end
