# = ユーザセッションモデルクラス
# Author:: oyajikun
#
# Authlogicを用いてユーザセッションを管理するモデルクラス
class UserSession < Authlogic::Session::Base
  logout_on_timeout true

  def initialize(*args)
    # password認証を優先
    return super(*args) unless args[0].blank?
    
    # 端末IDがない時は、通常ログインフローとみなす
    return super(*args) if args[1].blank?

    #TODO:params[:secret_url]を見て、ユーザに発行したURLかどうかの検証を行う
    #TODO:かんたんログインを許可しているか検証を行う

    user = User.find_by_uid(args[1])
    super(user)
  end
end
