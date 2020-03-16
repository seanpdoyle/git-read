require "application_system_test_case"

class VisitorViewsPreviousCommitTest < ApplicationSystemTestCase
  test "visitor views previous commit" do
    stage_file("README.md", "First version")
    commit("First commit")
    stage_file("README.md", "Middle version")
    commit("Middle commit")
    stage_file("README.md", "Last version")
    commit("Last commit")

    with_git_repository do
      visit "/index.html"
      click_on "Last commit"
      click_on "Previous"

      assert_selector "h1", text: "Middle commit"
    end
  end

  test "visitor views commit without a previous commit" do
    stage_file("README.md", "First version")
    commit("First commit")

    with_git_repository do
      visit "/index.html"
      click_on "First commit"

      assert_no_link "Previous"
    end
  end
end
