class UserMailer < ActionMailer::Base
  default :from => "maxwelltietze@gmail.com"
  
  def new_follower(user, follower)
    @user = user
    @follower = follower
    mail :to => "#{user.name} <#{user.email}>", :subject => "New Follower"
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end

  def confirm(user)
    @user = user
    mail :to => user.email, :subject => "Confirm New User"
  end
end