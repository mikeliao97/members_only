class SessionsController < ApplicationController
  attr_accessor :current_user
  def new
  end
  
  #In order to create a session, you must authenticate the user
  #Basically, you first find the user by his email
  #Then you authenticate the given user with some method
  #If everything works well session[:id] = User.id and also...kkkkkkkkkkkk
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = 'Thank you for signing in!'
      sign_in(user)
      redirect_to root_path
    else
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
