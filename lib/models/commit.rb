class Commit < SimpleDelegator
  def initialize(commit:, repository:)
    super(commit)
    @repository = repository
  end

  def subject
    message.lines.first
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
      gtree.files.map do |filename, _|
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

  private

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
