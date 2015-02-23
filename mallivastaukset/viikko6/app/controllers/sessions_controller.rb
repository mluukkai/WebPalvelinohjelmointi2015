class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password]) && (not user.is_frozen?)
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      notice = "Username and/or password mismatch"
      notice = "Your accout is frozen, please contact admin" if user.is_frozen?
      redirect_to :back, notice: notice
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end