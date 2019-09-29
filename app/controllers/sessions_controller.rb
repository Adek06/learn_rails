class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = '錯誤的郵箱/密碼'
      render 'new'
    end
    
  end

  def destory
    log_out
    redirect_to root_url
  end
end
