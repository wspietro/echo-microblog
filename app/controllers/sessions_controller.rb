class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user&.authenticate(session_params[:password])
      # nos previne contra session fixation
      # invalida sessao atual e cria uma nova
      reset_session
      log_in user
      remember user
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination."
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
