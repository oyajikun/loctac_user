class LocationsController < ApplicationController
  before_filter :require_login

  def new
    session[:location_state] = "start"
  end

  def regist
    redirect_to :action => :result
  end

  def result
    # TODO:location_state が start でない場合は不正アクセスとみなす
    
    pp session[:location_status]
    session[:location_state] = nil
    pp session[:location_status]
  end
end
