# == Schema Information
# Schema version: 20110319181904
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
class User < ActiveRecord::Base

	#defines what can be accessed
	#virtual
	attr_accessor :password
	#regular accessors
	attr_accessible :name, :email, :password, :password_confirmation
	
	
	has_many :microposts, :dependent => :destroy
	has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
	
	has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => "Relationship", :dependent => :destroy
	has_many :followers, :through => :reverse_relationships, :source => :follower
	
	has_many :following, :through => :relationships, :source => :followed
	
	#uses a regular expression for email validation
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	#validates user information
	validates :name, :presence => true, :length => { :maximum => 50 }
	
	validates :email, :presence => true, :format   => { :with => email_regex }, :uniqueness => { :case_sensitive => false }
	
	validates :password, :presence => true, :confirmation => true, :length => {:within => 6..40}
	
	#encrypts the password before saving it
	before_save :encrypt_password
	
	def has_password?(submitted_password)
		#compares the user's submitted password 
		#(encrypted) with the stored one (encrypted)
		encrypted_password == encrypt(submitted_password)
	end
	
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		if user.nil?
			return nil
		elsif user.has_password?(submitted_password)
			return user
		end
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		if user.nil?
			return nil
		elsif user.salt == cookie_salt
			return user
		end
	end
	
	def feed
		Micropost.from_users_followed_by(self)
	end	
	
	def following?(followed)
		relationships.find_by_followed_id(followed)
	end
	
	def follow!(followed)
		relationships.create!(:followed_id => followed.id)
	end
	
	def unfollow!(followed)
		relationships.find_by_followed_id(followed).destroy
	end
	
	private
	
		#makes a new salt if this is the first time 
		#Then, encrypts password
		def encrypt_password
			if new_record?
				self.salt = make_salt
			end
			self.encrypted_password = encrypt(password)
		end
	
	
		#actually encrypts
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end	
		
		#makes the salt
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		#actually makes the hash
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
