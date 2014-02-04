module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    #unencrypted token get stored in cookies for as long as user does not sign out
    cookies.permanent[:remember_token] = remember_token
    # encrypted token gets stored in the user's remember_token column in db
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def current_user=(user)
    @current_user = user
  end

  def current_user
    #encrypt remember token stored in cookie
    remember_token = User.encrypt(cookies[:remember_token])
    #set current user based on encrypted token which has been stored in db under 
    #remember_token column
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
end