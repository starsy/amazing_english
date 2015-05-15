class UserSessionsController < ApplicationController
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
    logout
    flash[:success] = "Goodbye!"
    redirect_to(:users)
  end



end
