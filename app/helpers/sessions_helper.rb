module SessionsHelper

  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    # Chama o método remember do modelo User
    user.remember
    # Salva ID encriptado nos cookies
    cookies.permanent.signed[:user_id] = user.id
    # Salva token nos cookies
    cookies.permanent[:remember_token] = user.remember_token
  end

  # returns the current logged-in user (if any)
  def current_user
    if (user_id = session[:user_id])
      # Se tem sessão ativa, usa ela, memoizantion ||
      @current_user ||= User.find_by(id: user_id)
      # Se não tem sessão mas tem cookie
    elsif (user_id = cookies.signed[:user_id])
      # Verifica se o token do cookie bate com o hash no banco
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # returns true if the user is logged in
  def logged_in?
    !current_user.nil?
  end

  # forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # logs out the given user
  def log_out()
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
