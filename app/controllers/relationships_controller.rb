class RelationshipsController < ApplicationController
  before_action :signed_in_user

  respond_to :html, :js

  def create
    @user = User.find(params[:relationship][:followed_id])
    @current_user = current_user
    current_user.follow!(@user)
    if @user.followmail
      UserMailer.new_follower(@user, @current_user).deliver
    end
    respond_with @user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_with @user
  end
end