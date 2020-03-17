require "application_system_test_case"

class VisitorViewsBuiltSiteTest < ApplicationSystemTestCase
  test "visitor views built site" do
    stage_file("README.md", "Ignore me")
    commit("From the command line")

    with_built_output do
      visit root_path
      expand_history
      click_on "From the command line"

      assert_selector "h1", text: "From the command line"
    end
  end
end
