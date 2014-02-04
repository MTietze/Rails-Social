class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true 

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    #include posts from users followed by user, posts from user, and replies to user
    where("message_to IS NULL AND (in_reply_to IS NULL AND user_id IN (#{followed_user_ids}) 
          OR user_id = :user_id OR in_reply_to = :user_id)", user_id: user.id)
  end

  def self.message(user, toFrom)   
    if toFrom == "to"
      where("message_to = :user_id", user_id: user.id)
    elsif toFrom == "from"
      where("message_to IS NOT NULL AND user_id = :user_id", user_id: user.id)
    end
  end

  def self.search(search)
    if search
      where('lower(content) LIKE ?', "%#{search.downcase}%")
    else 
      all
    end
  end
end 

