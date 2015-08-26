class SessionsController < ApplicationController
  include SessionsHelper

  def new
    puts "inside new SessionsController"
  end

  def create

    puts "inside create SessionsController"

    require 'open-uri'
    require 'json'

    #request the email with help of the received token from OpenJUB-API
    user_info = open("https://api.jacobs-cs.club/user/me"+"?token="+params[:token])
    json = JSON.parse(user_info.read)
    email = json["email"]

    user = User.find_by(email: email)
    
    if user
      log_in(user, params[:token])
      render :js => "window.location = '#{user_path(session[:user_id])}'" #due to the ajax call
      user.update_attributes(token: params[:token])
    else
      username = json["username"]
      name = json["fullName"]
      token = params[:token]

      user = User.new(name: name, username: username, email: email, token: token)
      if user.save
        log_in(user, token)
        flash[:success] = "Welcome to JacobsMKT!"
        render :js => "window.location = '#{user_path(session[:user_id])}'" #due to the ajax call
      else
        flash[:warning] = "Ups! An unexpected error occured. Please try again in a few minutes."
        redirect_to root_url
      end
    end
  end


  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end