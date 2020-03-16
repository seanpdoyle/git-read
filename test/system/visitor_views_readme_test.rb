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
end
