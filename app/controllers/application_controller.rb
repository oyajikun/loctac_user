# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout 'default'
  
  helper_method :require_docomo_guid_query

  before_filter :debug

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  ###
  private
  ###

  def debug
#    logger.debug request.mobile.try(:ident_subscriber)
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def require_login
    unless current_user
      store_location
      flash[:notice] = t("flash.require.login", :default => "require login")
      redirect_to login_url
      return false
    end
  end

  def require_logout
    if current_user
      store_location
      flash[:notice] = t("flash.require.logout", :default => "require logout")
      redirect_to user_url
      return false
    end
  end

  def require_docomo_guid_query
#    request.mobile.is_a?(Jpmobile::Mobile::Docomo) ? {:guid => "ON"} : {}
  end
end
