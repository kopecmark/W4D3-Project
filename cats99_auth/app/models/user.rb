class User < ApplicationRecord
  
  validates :session_token, :user_name, uniqueness: true, presence: true 
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  before_validation :ensure_session_token
  
  attr_reader :password
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
  
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    if user && user.is_password?(password)
      user
    else
      nil
    end 
  end
end
