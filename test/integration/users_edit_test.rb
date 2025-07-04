require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:pietro)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
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

  test "successful edit without password" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"

    name = "Pietro Edit"
    email = "pietro-edit@example.com"
    test_user_input = { name: name,
                        email: email,
                        password: "",
                        password_confirmation: "" }
    patch(user_path, params: { user: test_user_input })

    assert_redirected_to @user

    assert_equal flash[:success], "Profile updated."
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)

    name = "Pietro Edit"
    email = "pietro-edit@example.com"
    test_user_input = { name: name,
                        email: email,
                        password: "",
                        password_confirmation: "" }
    patch user_path(@user), params: { user: test_user_input }

    assert_redirected_to @user

    assert_equal flash[:success], "Profile updated."
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email

    delete logout_path
    assert_not is_logged_in?

    log_in_as(@user)
    assert_nil session[:forwarding_url], nil
    assert_redirected_to @user
  end
end
