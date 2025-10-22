require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # This code is not idiomatically correct.
    # Não é correto pois definimos a associaçãp manualmente
    # O correto é utilizar o User e deixar o rails cuidar da associação declarada no model
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
  end

  test "microspost should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = ""
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
end
