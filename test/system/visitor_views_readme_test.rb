require "application_system_test_case"

class VisitorViewsReadmeTest < ApplicationSystemTestCase
  test "visitor views README" do
    stage_file("README.md", <<~MARKDOWN)
    git-read
    ===

    Hello, from tests!
    MARKDOWN
    commit("Initial Commit")

    with_git_repository do
      visit root_path

      assert_title "git-read"
      assert_selector "h1", text: "git-read"
      assert_selector "p", text: "Hello, from tests!"
    end
  end

  test "visitor navigates to initial commit from README" do
    stage_file("README.md", "The README")
    commit(<<~MARKDOWN)
      Initial Commit
      ===

      The first commit
    MARKDOWN

    with_git_repository do |directory|
      visit root_path
      click_on "Get Started"

      assert_selector "h1", text: "Initial Commit"
      assert_selector "p", text: "The first commit"
    end
  end

  test "visitor navigates to README from another page" do
    stage_file("README.md", "The README")
    commit("Initial Commit")
    stage_file("ignored.txt", "ignore me")
    commit("Last commit")

    with_git_repository do |directory|
      visit root_path
      click_on "Last commit"
      click_on directory.basename.to_s

      assert_text "The README"
    end
  end

  test "link to GET STARTED from the README skips [GENERATED] and [SKIP] commits" do
    stage_file("README.md", "The README")
    commit("[SKIP] First Commit")
    stage_file("ignored.txt", "ignore me")
    commit("[GENERATED] Second commit")
    stage_file("included.txt", "included text")
    commit("Third commit")

    with_git_repository do |directory|
      visit root_path
      click_on "Get Started"
      click_on directory.basename.to_s

      assert_text "included text"
    end
  end
end
