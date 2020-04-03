module UrlHelpers
  def commit_path(commit)
    "/commits/#{commit.sha}/index.html"
  end

  def tag_path(tag)
    case tag
    when String
      "/tags/#{tag}/index.html"
    else
      "/tags/#{tag.name}/index.html"
    end
  end

  def root_path(commit = nil)
    if commit.respond_to? :name
      tag_path(commit)
    else
      "/index.html"
    end
  end
end
