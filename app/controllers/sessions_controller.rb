class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
    else
      flash.now[:danger] = "Invalid email/password combination."
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
