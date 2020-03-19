class Commit < SimpleDelegator
  def initialize(commit:)
    super(commit)
  end

  def subject
    message.lines.first
  end
end
