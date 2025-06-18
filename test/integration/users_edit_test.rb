require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:pietro)
  end

  test "invalid edit information" do
    get edit_user_path(@user)
    assert_template "users/edit"

    test_user_input = { name: "",
                        email: "user@invalid",
                        password: "foo",
                        password_confirmation: "bar" }
    patch(user_path, params: { user: test_user_input })

    assert_template "users/edit"
    assert_response :unprocessable_entity
    assert_select "p.input-error-message"
    assert_select "p", "Name can't be blank"
    assert_select "p", "Email is invalid"
    assert_select "p", "Password is too short (minimum is 6 characters)"
    assert_select "p", "Password confirmation doesn't match Password"

    @user.reload
    assert_not_equal "", @user.name
    assert_not_equal "user@invalid", @user.email
  end
end
