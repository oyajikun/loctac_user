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

  def require_docomo_guid_query
#    request.mobile.is_a?(Jpmobile::Mobile::Docomo) ? {:guid => "ON"} : {}
  end
end
