class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  before_action :signed_out_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :not_current_user, only: :destroy 


  def new
  	@user = User.new
  end 

  def confirm
    @user = User.find_by_remember_token!(params[:id])
  end

  def activate
    @user = User.find_by_remember_token!(params[:id])
    @user.update_attribute(:state, "active")
    sign_in @user
    redirect_to root_url
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

   def create
    @user = User.new(user_params)    
    if @user.save
      flash[:success] = "Please check your email to confirm!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user 
    else 
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def toggle_followmail
    @user = User.find(params[:id])
    @user.toggle!(:followmail)
    render :nothing => true
  end

  private

    # Before filters

    def signed_out_user
      if signed_in? 
        redirect_to root_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?  
    end

    def not_current_user
      @user = User.find(params[:id]) 
      if current_user?(@user)
        redirect_to users_path, notice: "You can't delete yourself!"
      end
    end
end

