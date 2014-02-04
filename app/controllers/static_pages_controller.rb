class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:inbox, :outbox]

  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page]).search(params[:search])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def inbox
    @feed_items = current_user.messages("to").paginate(page: params[:page]).search(params[:search])
  end

  def outbox
    @feed_items = current_user.messages("from").paginate(page: params[:page]).search(params[:search])
  end
end
