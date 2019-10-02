class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "請到先前邦定的郵箱裏激活"
        redirect_to root_url
      end
    else
      flash.now[:danger] = '錯誤的郵箱/密碼'
      render 'new'
    end
    
  end

  def destory
    log_out if logged_in?
    redirect_to root_url
  end
end
