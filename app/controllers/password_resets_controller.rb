class PasswordResetsController < ApplicationController
  before_action :get_user,         only:[:edit, :update]
  before_action :valid_user,       only:[:edit, :update]
  before_action :check_expiration, only:[:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
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

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "不能爲空")
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "密碼已經重設"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id])
              )
          redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "鏈接已失效"
        redirect_to new_password_reset_url
      end
    end
  end