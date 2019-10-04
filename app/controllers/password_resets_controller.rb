class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: param[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "重設鏈接已經發送到郵箱裏，請儘快查收"
      redirect_to root_url
    else
      flash.now[:danger] = "該郵箱未注冊"
      render 'new'
    end
  end

  def edit
  end
end
