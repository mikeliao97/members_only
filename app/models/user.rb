class User < ActiveRecord::Base
  #I'm writing this note for comprehension
  #The website you visit has a remember_token_digest for you everytime you visit.
  #This remember_token that it has is 
  attr_accessor :remember_token
  before_save{ self.email = email.downcase }
  before_create :remember 
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false}
  validates :password, presence:true, length: {minimum: 6}
  has_secure_password

  #This method is use to create a password?
  #this creates a new random token
  def User.new_token
    SecureRandom.base64
  end
  
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end


  def remember
    self.remember_token = User.new_token #This sets user's remember_token attriute to random thing

    #this saves remember_digest into the User database. Got it. 
    #You also let the website's sessions and cookies have the remember digest
    update_attribute(:remember_digest, User.digest(remember_token)) 
  end

end
