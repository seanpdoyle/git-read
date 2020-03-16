require "application_system_test_case"

class VisitorViewsNextCommitTest < ApplicationSystemTestCase
  test "visitor views next commit" do
    stage_file("README.md", "First version")
    commit("First commit")
    stage_file("README.md", "Middle version")
    commit("Middle commit")
    stage_file("README.md", "Last version")
    commit("Last commit")

    with_git_repository do
      visit root_path
      click_on "First commit"
      click_on "Next"

      assert_selector "h1", text: "Middle commit"
    end
  end

  test "visitor views commit without a next commit" do
    stage_file("README.md", "First version")
    commit("First commit")

    with_git_repository do
      visit root_path
      click_on "First commit"

      assert_no_link "Next"
    end
  end
end
