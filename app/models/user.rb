class User < ApplicationRecord
  has_many :microposts
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  # Returns the hash digest of the given string.
  def self.digest(string)
  cost = ActiveModel::SecurePassword.min_cost ?
  BCrypt::Engine::MIN_COST :
  BCrypt::Engine.cost
  BCrypt::Password.create(string, cost: cost)
  end
  # Returns a random token.
def User.new_token
  SecureRandom.urlsafe_base64
end
  
#returen a users in database
def remember
  self.remember_token = User.new_token
  update_attribute(:remember_digest,
  User.digest(remember_token))
end

#Forget
def forget 
  update_attribute(:remember_digest,nil)
end 
# Returns true if the given token matches the digest.
def authenticated?(attribute, token)
  digest = send("#{attribute}_digest")
  return false if digest.nil?
  BCrypt::Password.new(digest).is_password?(token)
end
  
# Activates an account.
def activate
  update_attribute(:activated, true)
  update_attribute(:activated_at, Time.zone.now)
end
# Sends activation email.
def send_activation_email
  UserMailer.account_activation(self).deliver_now
end

#Returne true if password reset has expaired 
def  password_reset_expired?
  reset_sent_at < 2.hours.ago 
end
# Sets the password reset attributes.
def create_reset_digest
  self.reset_token = User.new_token
  update_attribute(:reset_digest, User.digest(reset_token))
  update_attribute(:reset_sent_at, Time.zone.now)
end
  # Sends password reset email.
def send_password_reset_email
  UserMailer.password_reset(self).deliver_now
end

# Defines a proto-feed.
# See "Following users" for the full implementation.
def feed
  following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
  Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id) 

end
#follow user 
def follow(other_user)
following << other_user 
end
#unfollowed user 
def unfollow(other_user)
following.delete(other_user)
end
#Returnd true is current user following other user 
def following?(other_user)
  following.include?(other_user)
end
private

# Converts email to all lower-case.
def downcase_email
  self.email = email.downcase
end

# Create the token and digest.
def create_activation_digest
  self.activation_token = User.new_token
  self.activation_digest = User.digest(activation_token)
end

  

end
  