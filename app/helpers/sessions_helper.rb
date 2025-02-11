module SessionsHelper

  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # returns the current logged-in user (if any)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # logs out the given user
  def log_out()
    reset_session
    @current_user = nil
  end

  # returns true if the user is logged in
  def logged_in?
    !current_user.nil?
  end
end
