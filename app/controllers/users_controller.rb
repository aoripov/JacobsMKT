class UsersController < ApplicationController
  include SessionsHelper

  def show
    @user = User.find(params[:id])
    unless logged_in? && eligible_for_viewing?(@user)
      redirect_to '/422.html'
    end
  end

  def new
    @user = User.new 
  end

  def create
    #moved to sessions

    require 'open-uri'
    require 'json'

    #fetch email with OpenJUB-API
    user_info = open("https://api.jacobs-cs.club/user/me"+"?token="+params[:token])
    json = JSON.parse(user_info.read)
    email = json["email"]
    username = json["username"]
    name = json["fullName"]
    token = params[:token]

    @user = User.new(name: name, username: username, email: email, token: token)
    if @user.save
      log_in(@user.id, token)
      flash[:success] = "Welcome to JacobsMKT!"
      render :js => "window.location = '#{@user}'" #due to the ajax call
    else
      flash[:warning] = "Ups! Looks like you are already registered. Try the normal login link."
      redirect_to login_path #why is this not working? => refers to /user/new
    end
  end

  def admin
    if admin?
      @users = User.all#.where.not(username: current_user.username)
    else
      redirect_to '/422.html'
    end
  end

  def make_admin
    unless admin?
      redirect_to '/422.html'
    else
      @user = User.find(params[:user_id])
      if @user.update_attributes(role: 1)
          redirect_to '/admin/users'
      else
        flash[:error] = "Error while updating user role."
      end

    end
  end

  def make_user
    unless admin?
      redirect_to '/422.html'
    else
      @user = User.find(params[:user_id])
      if @user.update_attributes(role: 3)
          redirect_to '/admin/users'
      else
        flash[:error] = "Error while updating user role."
      end

    end
  end


  private

    def user_params
      params.require(:user).permit(:email)
    end
end