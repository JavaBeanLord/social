class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :connections, foreign_key: "follower_id", dependent: :destroy
  # overrides the default with a more natural name with source:
  has_many :followed_users, through: :connections, source: :followed
  # simulates a table of reverse connections by setting followed_id as foreign key
  has_many :reverse_connections, foreign_key: "followed_id", class_name: "Connection", dependent: :destroy
  has_many :followers, through: :reverse_connections
  has_many :comments, :foreign_key => :commenter_id
  validates :name, presence: true, length: { minimum: 3 }
  validates :password, presence: true, length: { minimum: 4 }
  validates :email, presence: true, length: { minimum: 6 }
  validates :bio, presence: true, length: { minimum: 4 }
  
  def following?(other_user)
    connections.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    connections.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    connections.find_by(followed_id: other_user.id).destroy
  end
  
  def message!(sender, text)
    messages.create!(sender: sender, receiver: self, text: text)
  end
  
  def feed
    posts = Post.from_users_followed_by(self).sort_by(&:created_at).reverse!
  end
  
  def notify!(action, other_user)
    if self != other_user then
      case action
      when :follow
        message = "#{other_user.name} started following you."
      when :like_post
        message = "#{other_user.name} liked your post."
      when :like_comment
        message = "#{other_user.name} liked your comment."
      when :comment
        message = "#{other_user.name} commented on your post."
      end
      notifications.create!(message: message)
    end
  end
  
  def self.authenticate(name, password)
    user = find_by_name(name)
    if user && user.password == password
      user
    else
      nil
    end
  end
end
