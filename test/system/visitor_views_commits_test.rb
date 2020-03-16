require "application_system_test_case"

class VisitorViewsCommitsTest < ApplicationSystemTestCase
  test "visitor views commits" do
    stage_file("README.md", "Ignore me")
    commit("Ignore me")
    stage_file("file.txt", "Ignore me")
    commit(<<~MARKDOWN)
    The commit subject

    The commit body
    MARKDOWN

    with_git_repository do
      visit root_path
      click_on "The commit subject"

      assert_selector "h1", text: "The commit subject"
      assert_selector "p", text: "The commit body"
    end
  end

  test "visitor views commit with HTML in the subject line" do
    stage_file("README.md", "Ignore me")
    commit("This subject has a `<h1>` in it")

    with_git_repository do
      visit root_path

      assert_text "This subject has a `<h1>` in it"
    end
  end
end
