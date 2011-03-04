# = ユーザモデルクラス
# Author:: oyajikun
#
# エンドユーザを管理するモデルクラス
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout = 1.days
    c.validates_length_of_email_field_options = {:within => 8..100}
  end
  
  ###
  # association
  ###
  has_one :my_point, :dependent => :destroy
  #  has_one :my_profile, :dependent => :destory

  accepts_nested_attributes_for :my_point

  def initialize(params = nil)
    unless params.blank?
      params.update(
        {
          :my_point_attributes => {
            # 入会時ボーナスなどは、User#bonus で対応
            :point => 100
          }
        }
      )
    end

    super(params)
  end

  def bonus(bonus_point = 300)
    self.my_point.point = bonus_point
  end
end
