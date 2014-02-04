class SessionsController < ApplicationController
  
  def new
  end

  def create
  user = User.find_by(email: params[:email].downcase)
  if user && user.state == "active"  
    if user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  else
    flash.now[:error] = 'Please check your email to confirm account creation'
    render 'new'
  end
 end

  def destroy
    sign_out
    redirect_to root_url
  end
end
