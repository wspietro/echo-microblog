class UsersController < ApplicationController
  def show
    @user = User.find_by({ id: params[:id] })
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # handle a successful save.
      # we can omit the user_url(@user)
      flash[:success] = "Welcome to the Echo, #{@user[:name].split.first}!"
      redirect_to @user
    else
      render "new", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
