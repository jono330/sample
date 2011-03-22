class UsersController < ApplicationController
  def new
 	@title = "Sign Up"
  end
  
  def show
  	@title = "Users"
  	@user = User.find(params[:id])
  end
end
