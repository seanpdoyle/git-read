module UrlHelpers
  def commit_path(commit)
    "/commits/#{commit.sha}/index.html"
  end

  def tag_path(tag)
    "/tags/#{tag.name}/index.html"
  end

  def root_path(root = nil)
    if root.respond_to? :name
      tag_path(root)
    else
      "/index.html"
    end
  end
end
