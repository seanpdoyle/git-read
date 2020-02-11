module CommitHelpers
  def commit_path(commit)
    "/commits/#{commit.sha}/index.html"
  end
end
