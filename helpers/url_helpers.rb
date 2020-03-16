module UrlHelpers
  def commit_path(commit)
    "/commits/#{commit.sha}/index.html"
  end

  def root_path
    "/index.html"
  end
end
