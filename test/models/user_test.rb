require "test_helper"

class UserTest < ActiveSupport::TestCase
  # run before each test
  def setup
    @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar",
    )
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid address" do
    valid_addreses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addreses.each do |valid_address|
      @user.email = valid_address
      assert(@user.valid?, "#{valid_address.inspect} should be valid")
    end
  end

  test "email validation should reject invalid address" do
    invalid_addreses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addreses.each do |invalid_address|
      @user.email = invalid_address
      assert_not(@user.valid?, "#{invalid_address.inspect} should be invalid")
    end
  end

  test "emai address should be unique" do
    duplicate_user = @user.dup()
    duplicate_user.email = @user.email
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lowercase" do
    mixed_case_email = "Foo@ExaAmple.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal(mixed_case_email.downcase, @user.reload.email, "#{mixed_case_email.inspect} not saved as lowercase")
  end

  test "password should be present (nonblank)" do
    @user.password = " "
    @user.password_confirmation = " "
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = "a" * 5
    @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?("")
  end
end
