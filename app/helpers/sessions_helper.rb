module SessionsHelper

  # Logs in the given user.
  def log_in(user, token)
    session[:user_id] = user.id
    session[:jub_token] = token
  end
  
  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  def eligible_for_viewing?(user)
    current_user.id == user.id || admin?
  end

  def eligible_for_editing?(user)
    current_user.id == user.id || admin?
  end
  
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)

    #logout at OpenJUB
    response = open("https://api.jacobs-cs.club/user/me"+"?token="+session[:jub_token]) #make error check!
    session.delete(:jub_token)

    @current_user = nil
  end

  def admin?
    if current_user.nil?
      false 
    else
      current_user.role == 1
    end
  end

  def roleToString(role)
    case role
    when 1
      'admin'
    when 2
      'editor'
    when 3
      'user'
    else
      'no role'
    end
  end

end
