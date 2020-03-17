require "test_helper"

class GitReadTest < ActiveSupport::TestCase
  test "bin/git-read --help exits with a 0 status" do
    system("bin/git-read --help", exception: true)

    assert_equal(0, $?)
  end
end
