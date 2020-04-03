require "application_system_test_case"

class VisitorViewsCommitDiffTest < ApplicationSystemTestCase
  test "visitor views commit diff when it is the first commit" do
    stage_file("README.md", "Ignore me")
    stage_file("file.txt", "File contents")
    stage_file("src/file.txt", "Nested file contents")
    git_commit = commit("First commit")

    with_git_repository do
      visit commit_path(git_commit)

      assert_selector "details summary", text: "file.txt"
      assert_selector "details[open]", text: "File contents"
      assert_selector "details summary", text: "src/file.txt"
      assert_selector "details[open]", text: "Nested file contents"
    end
  end

  test "visitor views commit diff when it has parents" do
    stage_file("README.md", "Ignore me")
    stage_file("file.txt", <<~TEXT)
      First line
    TEXT
    commit("First commit")
    stage_file("file.txt", <<~TEXT)
      First line
      Next line
    TEXT
    git_commit = commit("Last commit")

    with_git_repository do
      visit commit_path(git_commit)

      assert_selector "details summary", text: "file.txt"
      assert_selector "details[open]", text: "+Next line"
    end
  end

  test "collapses diffs for files that have more than 100 lines" do
    stage_file("README.md", "Ignore me")
    stage_file("file.txt", 101.times.reduce("") { |lines| lines + "\ndiff line" })
    git_commit = commit("First commit")

    with_git_repository do
      visit commit_path(git_commit)

      assert_no_selector "details[open]", text: "diff line"
    end
  end

  test "collapses diffs for commits that start with [GENERATED]" do
    stage_file("README.md", "Ignore me")
    stage_file("file.txt", "File contents")
    git_commit = commit("[GENERATED] Initial Commit")

    with_git_repository do
      visit commit_path(git_commit)

      assert_no_selector "details[open]", text: "File contents"
    end
  end

  test "visitor views home page" do
    stage_file("README.md", "Ignore me")
    stage_file("file.txt", "File contents")
    commit("First commit")

    with_git_repository do
      visit root_path

      assert_no_text "File contents"
    end
  end
end
