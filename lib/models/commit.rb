class Commit < SimpleDelegator
  def initialize(commit:, repository:)
    super(commit)
    @repository = repository
  end

  def subject
    message.lines.first.strip
  end

  def diff_files
    if parent.present?
      parent.diff(self).map do |file|
        contents = file.patch

        {
          subject: subject,
          name: file.path,
          language: "diff",
          contents: contents,
          expanded: expanded?(contents),
        }
      end
    else
      files_in_tree(node: gtree).flat_map do |filename|
        contents = show_root_diff(filename)

        {
          subject: subject,
          name: filename,
          language: "diff",
          contents: contents,
          expanded: expanded?(contents),
        }
      end
    end
  end

  def skip?
    generated? || subject.start_with?("[SKIP]")
  end

  private

  def files_in_tree(node:, parents: [])
    files = node.files.map { |file, _| File.join(*parents, file) }

    files_from_leafs = node.subtrees.map do |child, root|
      files_in_tree(node: root, parents: parents + [child])
    end

    files + files_from_leafs.flatten
  end

  def generated?
    subject.start_with?("[GENERATED]")
  end

  def expanded?(contents)
    !generated? && contents.lines.count < 100
  end

  def show_root_diff(filename)
    @repository.lib.send(:command, "show", [
      "--cc",
      %(--format=%n),
      sha,
      "--",
      filename,
    ]).strip
  end
end
