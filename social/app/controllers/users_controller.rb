class UsersController < ApplicationController
  
  def search
    if params[:query]
      @users = User.find_by_sql("SELECT * FROM Users WHERE name = '#{params[:query]}'")
    end
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end
  
  def following
    @user = User.find(params[:id])
    @users = @user.followed_users
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user].permit(:email, :password, :name))
    
    if @user.save
      user = User.last
      # maybe potentially be unsecure
      session[:user_id] = user.id if user
      redirect_to root_url
    else
      render "new"
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    if @user.update(params[:user].permit(:profile_picture, :bio))
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def show
    @user = User.find(params[:id])
    @post = Post.new
  end
  
  def index
    @users = User.all
  end
end
