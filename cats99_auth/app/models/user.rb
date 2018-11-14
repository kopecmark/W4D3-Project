class User < ApplicationRecord
  
  validates :session_token, :user_name, uniqueness: true, presence: true 
  validates :password_digest, presence: true
  
  def self.reset_session_token!
    self.session_token = SecureRandom.base64
    self.save!
    self.session_token
  end
end
