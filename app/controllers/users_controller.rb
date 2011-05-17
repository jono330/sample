class UsersController < ApplicationController

  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :anti_authenticate, :only => [:new, :create]
  
  def index
	@title = "All Users"
	@users = User.paginate(:page => params[:page])
  end
  
  def new
	@user = User.new
 	@title = "Sign Up"
  end
  
  def show
	@user = User.find(params[:id])
	@microposts = @user.microposts.paginate(:page => params[:page])
  	@title = @user.name
  end
  
  def create
	@user = User.new(params[:user])
	if @user.save
		sign_in @user
		flash[:success] = "Welcome to the Govie Market!"
		redirect_to @user
	else
		@title = "Sign Up"
		@user.password = ""
		render 'new'
	end
  end
  
  def edit
	@title = "Edit User"
  end
  
  def update
	@user = User.find(params[:id])
	if @user.update_attributes(params[:user])
		flash[:success] = "Profile Updated"
		redirect_to @user
	else
		@title = "Edit User"
		render 'edit'
	end
  end
  
  def destroy
	user_tbd = User.find(params[:id])
	
	if current_user?(user_tbd)
		redirect_to(users_path)
		flash[:notice] = "You cant delete yourself"
	else
		user_tbd.destroy
		flash[:success] = "User Deleted"
		redirect_to(users_path)
	end
  end
  
  def following
	@title = "Following"
	@user = User.find(params[:id])
	@users = @user.following.paginate(:page => params[:page])
	render 'show_follow'
  end
  
  def followers
	@title = "Followers"
	@user = User.find(params[:id])
	@users = @user.followers.paginate(:page => params[:page])
	render 'show_follow'
  end
  
  private
	
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_path) unless current_user?(@user)
	end
	
	def admin_user
		redirect_to(root_path) unless current_user.admin?
	end
	
	def anti_authenticate
		if signed_in?
			redirect_to(root_path)
		end
	end
end
