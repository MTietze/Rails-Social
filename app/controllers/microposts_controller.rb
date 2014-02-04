class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    
    #Check if the post is a reply or message
    postType(@micropost)
    
    if @micropost.save 
      if @micropost.message_to.nil?
        flash[:success] = "Your post has been created!"
      else 
        flash[:success] = "Your message has been sent!"
      end
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  
  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def postType(post)
      firstChar = post.content.lstrip[0]
      if firstChar == '@'
        reg = /@\S*\s/.match(post.content)
        #Convert user name back from underscores to spaces plus remove "@ or *" and final white space    
        recipient = (reg[0].gsub("_", " "))[1..-2] 
        unless User.find_by(name: recipient).nil?
          post.in_reply_to = User.find_by(name: recipient).id
        end
      elsif firstChar == '*'
        reg = /\*\S*\s/.match(post.content)
        recipient = (reg[0].gsub("_", " "))[1..-2] 
        unless User.find_by(name: recipient).nil?
          post.message_to = User.find_by(name: recipient).id
        end
      end
    end
end