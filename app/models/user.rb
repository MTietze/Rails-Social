class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy 
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  VALID_NAME_REGEX = /\A[^_]*\Z/
      validates :name, presence: true, length: { maximum: 50 }, uniqueness: true, 
                                        format: { with: VALID_NAME_REGEX }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i 
      validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
                                  uniqueness: { case_sensitive: false }
      validates :password, length: { minimum: 6 }
  before_save { email.downcase! }
  before_create :create_remember_token
  after_create :send_confirm
  has_secure_password
  default_scope -> { order('upper(name)') }
 
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def send_password_reset
    self.update_attribute(:remember_token, User.new_remember_token)
    self.update_attribute(:remember_token_sent_at, Time.current)
    UserMailer.password_reset(self).deliver
  end

  def send_confirm
    UserMailer.confirm(self).deliver
  end

  def self.search(search)
    if search
      where("lower(name) LIKE ?", "%#{search.downcase}%")
    else 
      all
    end
  end

  def feed
    Micropost.from_users_followed_by(self)  
  end

  def messages(origin)
    Micropost.message(self, origin)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

  
  private
  def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end   
end