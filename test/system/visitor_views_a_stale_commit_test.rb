require "application_system_test_case"

class VisitorViewsAStaleCommitTest < ApplicationSystemTestCase
  test "visitor views a stale commit" do
    stage_file("README.md", "Ignore me ")
    commit("Initial commit")
    branch_commit_sha = switch_branch("my-branch") do
      stage_file("file.txt", "Ignore me")
      commit("Hello from the branch")
      tag_head_commit("my-tag")
    end

    with_git_repository do
      visit commit_path(branch_commit_sha)
      expand_history

      assert_text "You're viewing an out-of-date version of the project."
      assert_selector "a", text: "Read the latest version."
      assert_selector "h1", text: "Hello from the branch"
      assert_selector "[aria-current]", text: "Hello from the branch"
    end
  end

  test "visitor views stale README" do
    stage_file("README.md", "Ignore me ")
    commit("Initial commit")
    branch_commit_sha = switch_branch("my-branch") do
      stage_file("README.md", "# Tagged README")
      commit("Hello from the branch")
      tag_head_commit("my-tag")
    end

    with_git_repository do
      visit tag_path("my-tag")
      expand_history

      assert_text "You're viewing an out-of-date version of the project."
      assert_selector "h1", text: "Tagged README"
    end
  end

  test "visitor navigates to the stale root" do
    stage_file("README.md", "README contents from the main branch")
    commit("Initial commit")
    branch_commit_sha = switch_branch("my-branch") do
      stage_file("file.txt", "Ignore me")
      commit("Hello from the branch")
      tag_head_commit("my-tag")
    end

    with_git_repository do |directory|
      visit commit_path(branch_commit_sha)
      click_on directory.basename
      expand_history

      assert_text "You're viewing an out-of-date version of the project."
      assert_text "README contents from the main branch"
      assert_selector "a", text: "Hello from the branch"
    end
  end

  test "visitor views a does not see stale commit from main branch" do
    stage_file("README.md", "Ignore me")
    commit("Hello from main branch")
    switch_branch("my-branch") do
      stage_file("file.txt", "Ignore me")
      commit("Hello from the branch")
      tag_head_commit("my-tag")
    end

    with_git_repository do
      visit root_path
      expand_history

      assert_selector "a", text: "Hello from main branch"
      assert_no_text "You're viewing an out-of-date version of the project."
      assert_no_selector "a", text: "Read the latest version."
      assert_no_selector "a", text: "Hello from the branch"
    end
  end
end
