class LocationsController < ApplicationController
  # 位置情報はキャリアゲートウェイから POST されるので、CSRF対策を無効化する必要がある。
  # アクセス元IP制限や暗号化したトークン内のデータにて、ユーザと有効期限を判定しているので問題ないと思われる。
  protect_from_forgery :except => [:regist]
  
  before_filter :require_login
  before_filter :validates_in_registration, :only => [:regist]

  def new
    session[:location_state] = "start"
  end

  def regist
    # TODO:位置登録処理、宝箱（ゴールド、アイテム）を発見したり、店舗を発見したり、ユニットを発見したり
    # TODO:トランザクションが正常に完了したら、state を初期化する
    session[:location_state] = nil

    redirect_to :action => :result
  end

  def result
  end

  ###
  private
  ###

  def validates_in_registration
    # location_state が start でない場合は不正アクセスとみなす
    unless session[:location_state] == "start"
      render :text => "location_state is invalid"
      return false
    end

    # このトークンには有効期限が含まれているので、有効期限かどうかチェックする
    if Time.now > DateTime.strptime(request.env["decrypted_token"][:expired_at], I18n.t("time.formats.long2"))
      render :text => "this request is expire."
      return false
    end
  end
end
