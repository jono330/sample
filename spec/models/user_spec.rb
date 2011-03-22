require 'spec_helper'

describe User do
  
  before(:each) do
  	@attr = {:name => "Example User", :email => "user@example.com"}
  end
  
  it "should reject names that are too long" do
 	long_name = "a" * 51
 	long_name_user = User.new(@attr.merge(:name => long_name))
 	long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
	adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
	adresses.each do |address|
		valid_email_user = User.new(@attr.merge(:email => address))
		valid_email_user.should be_valid
	end
  end
  
  it "should not accept invalid email addresses" do
	adresses = %w[user@foo,com user_at_foo.org first.last@foo.]
	adresses.each do |address|
		invalid_user_email = User.new(@attr.merge(:email => address))
		invalid_user_email.should_not be_valid
	end
  end
  
  it "should reject duplicate email addresses" do
  	#put a given user w/ given email into the database
  	User.create!(@attr)
  	user_with_duplicate_email = User.new(@attr)
  	user_with_duplicate_email.should_not be_valid 	
  end
  
  it "should reject duplicate email addresses up to case" do
  	#put a given user w/ given email into the database
  	upcased_email = @attr[:email].upcase
  	User.create!(@attr.merge(:email => upcased_email))
  	user_with_duplicate_email = User.new(@attr)
  	user_with_duplicate_email.should_not be_valid 	
  end
end
