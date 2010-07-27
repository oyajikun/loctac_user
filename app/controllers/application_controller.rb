# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout 'default'
  
  before_filter :debug

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  ###
  private
  ###

  def debug
    logger.debug request.mobile.carrier
    logger.debug request.mobile.try(:guid)
    logger.debug request.mobile.docomo? ? "docomo" : "not docomo"
    logger.debug request.mobile.au? ? "au" : "not au"
    logger.debug request.mobile.softbank? ? "softbank" : "not softbank"
  end
end
