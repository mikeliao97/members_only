class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #When you sign in the user
  #session[:id] = user.id 
  #user gets a new remember token
  #cookies.permanent[:remember_digest] = 
  def sign_in(user)
    remember_token = User.new_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_digest, User.digest(remember_token))
    cookies.permanent.signed[:user_id] = user.id
    self.current_user = user
  end

  #this sets the user
  #The session has a current user
  
  
  def current_user=(user)
    @current_user = user  
  end

  #current user checks the user based on the sessions remember_token
  #
  def current_user
    remember_digest = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_digest: remember_digest)
  end

  helper_method :signed_in?, :current_user
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    session.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
