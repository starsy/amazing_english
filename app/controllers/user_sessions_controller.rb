class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      flash[:success] = "Welcome, #{@user.email}"
      redirect_back_or_to(:root)
    else
      flash[:warning] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    @user = current_user
    logout
    flash[:success] = "Goodbye #{@user.email}!"
    redirect_to(:root)
  end



end
