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
      visit "/index.html"

      assert_title "git-read"
      assert_selector "h1", text: "git-read"
      assert_selector "p", text: "Hello, from tests!"
    end
  end

  test "visitor navigates to README from another page" do
    stage_file("README.md", "The README")
    commit("Initial Commit")
    stage_file("ignored.txt", "ignore me")
    commit("Last commit")

    with_git_repository do |directory|
      visit "/index.html"
      click_on "Last commit"
      click_on directory.basename.to_s

      assert_text "The README"
    end
  end
end
