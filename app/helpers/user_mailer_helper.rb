module UserMailerHelper
  
  def confirm_link
    if Rails.env.production? 
      "rails-social.herokuapp.com/users/#{@user.remember_token}/confirm" 
    else   
      confirm_user_url(@user.remember_token)
    end 
  end
end