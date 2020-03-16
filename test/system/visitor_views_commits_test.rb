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
      expand_history
      click_on "The commit subject"
      expand_history

      assert_selector "h1", text: "The commit subject"
      assert_selector "p", text: "The commit body"
      assert_selector "[aria-current]", text: "The commit subject"
    end
  end

  test "visitor views commit with HTML in the subject line" do
    stage_file("README.md", "Ignore me")
    commit("This subject has a `<h1>` in it")

    with_git_repository do
      visit root_path
      expand_history

      assert_text "This subject has a <h1> in it"
    end
  end
end
