module UrlHelpers
  def commit_path(commit)
    "#{config[:path_prefix]}/commits/#{commit.sha}/index.html"
  end

  def tag_path(tag)
    "#{config[:path_prefix]}/tags/#{tag.name}/index.html"
  end

  def root_path(root = nil)
    if root.respond_to? :name
      tag_path(root)
    else
      "#{config[:path_prefix]}/index.html"
    end
  end
end
