require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      test_user_input = { name: "",
                          email: "user@invalid",
                          password: "foo",
                          password_confirmation: "bar" }
      post(users_path, params: { user: test_user_input })
    end

    assert_response :unprocessable_entity
    assert_template "users/new"
    assert_select "p.input-error-message"
    assert_select "p.input-error-message"
    assert_select "p", "Name can't be blank"
    assert_select "p", "Password is too short (minimum is 6 characters)"
    assert_select "p", "Password confirmation doesn't match Password"
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      test_user_input = { name: "Valid User",
                          email: "user@valid.com",
                          password: "foobar",
                          password_confirmation: "foobar" }
      post(users_path, params: { user: test_user_input })
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup
  def setup
    super
    test_user_input = { name: "Valid User",
                        email: "user@valid.com",
                        password: "foobar",
                        password_confirmation: "foobar" }
    post(users_path, params: { user: test_user_input })
    @user = assigns(:user)
  end

  test "should not be activated" do
    assert_not @user.activated?
  end

  test "should not be able to log in before account activation" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid activation token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid email" do
    get edit_account_activation_path(@user.activation_token, email: "invalid@email.com")
    assert_not is_logged_in?
  end

  test "should successfully log in with valid activation token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert is_logged_in?

    assert_redirected_to @user

    follow_redirect!
    assert_template "users/show"

    assert_equal flash[:success], "Account activated!"
  end
end
