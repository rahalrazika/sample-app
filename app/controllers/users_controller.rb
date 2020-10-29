class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

def index 
  @users = User.paginate(page: params[:page])

end
def show
  @user = User.find(params[:id])
end

def new
  @user = User.new
end

def create
  @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
end

def edit
end

def update
  if @user.update(user_params)
    flash[:success] = "Profile Updated "
    redirect_to @user
  else
    render 'edit'
  end
end
private
  def user_params
    params.require(:user).permit(:name, :email, :password,
    :password_confirmation)
  end

  #before filtres 
  #confirm a logged-in user 
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "please log in "
      redirect_to login_url 
    end    
  end
  # Confirms the correct user.
def correct_user
  @user = User.find(params[:id])
  redirect_to(root_url) unless current_user?(@user)
  end
  
end