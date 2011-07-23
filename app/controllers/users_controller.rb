class UsersController < ApplicationController

  def index
  end

  def register

      if request.post?
        @user = User.new(params[:user])
        if @user.save
          flash[:notice] = "New user registered"
          redirect_to :action => "index"
        end
      end

  end

  def login

    if request.post?

      # find user
      @user = User.where(:username => params["username"]).first
      unless @user
        flash[:notice] = "Username not recognised"
        return
      end

      # check password
      unless @user.check_password params["password"]
        flash[:notice] = "Password incorrect"
        return
      end

      # log them on
      session[:username] = @user.username
      flash[:notice] = "Logged in successfully"
      redirect_to :action => "index"

    end

  end

end
