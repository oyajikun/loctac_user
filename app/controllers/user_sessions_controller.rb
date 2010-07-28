class UserSessionsController < ApplicationController
  before_filter :require_logout, :only => [:new, :create]
  before_filter :require_login, :only => [:destroy]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session], request.mobile.try(:guid))
    respond_to do |format|
      if @user_session.save
        flash[:notice] = I18n.t("flash.login.success", :default => "login success")
        format.html { redirect_back_or_default user_url }
      else
        flash[:notice] = I18n.t("flash.login.failure", :default => "login failure")
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = I18n.t("flash.logout.done", :default => "logout done")
    respond_to do |format|
      format.html { redirect_to(login_url) }
    end
  end
end
