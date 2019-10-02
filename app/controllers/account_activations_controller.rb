class AccountActivationsController < ApplicationController

    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.update_attribute(:activated, true)
            user.update_attribute(:activated_at, Time.zone.now)
            log_in user
            flash[:success] = "激活成功"
            redirect_to user
        else
            flash[:danger] = "非法激活鏈接"
            redirect_to root_url
        end
    end
end
