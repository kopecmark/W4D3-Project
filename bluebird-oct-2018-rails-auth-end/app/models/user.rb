class User < ApplicationRecord
  # Only username and session_token need to be unique, NOT password_digest
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  # We want to validate that, if a password is provided, it has a length of at least 6
  # We want to allow nil since we won't always include password in our params (example: update action)
  # This validation requires a @password instance variable to be set as well as an attr_reader
  validates :password, length: { minimum: 6, allow_nil: true }

  # We need to add an attr_reader on password so our validation can read it
  attr_reader :password

  # before validation takes a list of symbols representing methods to call right before
  # our validations are run.
  # We want to make sure that, when we create a new user, they have a session_token
  # Otherwise our model and database validations will fail
  before_validation :ensure_session_token

  def password=(password)
    # Use the built in setter for password digest (ActiveRecord) to assign the hash
    self.password_digest = BCrypt::Password.create(password)
    # Create a new instance variable, @password, to use for validation later
    @password = password
  end

  def ensure_session_token
    # since this method is run everytime we validate, we only want to assign session_token
    # if it isn't already provided. Otherwise, we'll reset it when we update as well
    # and log out our user!
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    # We want to call this method any time we're: 
    # logging in a user - to ensure they aren't left logged in elsewhere
    # logging out a user - to ensure their session_token is no good once they log out
    self.session_token = SecureRandom::urlsafe_base64
    # make sure the new token persists!
    self.save!
    # return the new token for convenience
    self.session_token
  end

  def self.find_by_credentials(username, password)
    # find a user by their username
    user = User.find_by(username: username)
    # check if the user exists (username is in db) AND the password is correct (using instance method)
    if user && user.is_password?(password)
      user
    else
      # if username isn't found, or password is incorrect, return nil
      nil
    end
  end

  def is_password?(password)
    # Bcrypt::Password.new() takes an existing digest and returns a Bcrypt Password instance
    # It looks like a string, but check out its `.class` method!
    # We can call `.is_password?` on the instance, passing a string of our submitted password
    # Bcrypt will be able to tell if the digest was generated from that password, and returns a boolean
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
