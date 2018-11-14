class ApplicationController < ActionController::Base
  helper_method :current_user
  
  def login(user)
    session[:session_token] = user.reset_session_token!
  end

  def current_user
    # We use the session[:session_token] to find our user
    # We conditionally assign the @current_user ivar to avoid 
    # querying the database more than once
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logout!
    # setting the session_token to nil is *technically* all we need, but we also want to make sure to clean up our instance variables just in case
    # We'll also reset the current_user's session token to ensure that it's unique each time – this is redundant, but ensures that if the session_token was captured somehow it couldn't be used to 'spoof' a log in
    session[:session_token] = nil
    # checking for current_user is only necessary to handle the case when logout is called while logged out – it shouldn't ever happen but we don't want to get an undefined method for nil error
    if current_user
      @current_user.reset_session_token!
    end
    # We should clear this instance variable to ensure `current_user` returns nil – only really necessary if we `render` from the destroy route instead of redirecting
    @current_user = nil
  end
end
