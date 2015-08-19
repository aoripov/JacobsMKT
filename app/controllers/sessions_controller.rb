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
      puts 'user found'
      log_in(user, params[:token])
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      #redirect_to( user_path(session[:user_id]), format: :html, remote: true)
      render :js => "window.location = '#{user_path(session[:user_id])}'" #due to the ajax call
      #render "/user/show/"+user[:user_id]
      user.update_attributes(token: params[:token])
    else

      flash[:warning] = "Ups! An unexpected error occured. Please try again in a few minutes."

    end

  end


  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end