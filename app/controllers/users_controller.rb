class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:index, :show, :edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # handle a successful save.
      # we can omit the user_url(@user)
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Echo, #{@user[:name].split.first}!"
      redirect_to @user
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    # We can use the before_action :correct_user to set @user
    # @user = User.find(params[:id])
  end

  def update
    # We can use the before_action :correct_user to set @user
    # @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless @user == current_user
  end
end
