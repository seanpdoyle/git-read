module CommitHelpers
  def commit?
    current_page.data.id.present?
  end

  def current?(commit)
    [
      current_page.data.id,
      commit.id
    ].map(&:to_s).uniq.size == 1
  end

  def commit_path(commit)
    "/commits/#{commit.id}/"
  end
end
