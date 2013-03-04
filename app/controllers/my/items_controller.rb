# encoding: utf-8


# 在庫管理用コントローラ
#
# @author tk.hamaguchi@gmail.com
# @since 2.0.0
#
class My::ItemsController < MyController

  before_filter :parse_character_items_stocks, :only => [:updates]

  # 在庫情報一覧
  #
  # @example 在庫情報確認ページ
  # +GET /my/items(.html)
  # +
  # +render 'Rails.root/app/view/my/items/index.html.erb'
  #
  # @example 在庫情報取得API
  # +GET /my/items.json
  # +
  # +{
  # ++"characters": [
  # +++{
  # ++++"id": 1,
  # ++++"name": "きゃら"
  # +++},
  # +++{
  # ++++"id": 2,
  # ++++"name": "サブきゃら"
  # +++}
  # ++],
  # ++"items": [
  # +++{
  # ++++"id": 1,
  # ++++"character_id": 2,
  # ++++"name": "どうのこうせき",
  # ++++"kana": "どうのこうせき",
  # ++++"cost": 30,
  # ++++"stock":2
  # +++},
  # +++{
  # ++++"id": 2,
  # ++++"character_id": 1,
  # ++++"name": "じょうぶな枝",
  # ++++"kana": "じょうぶなえだ",
  # ++++"cost": 40,
  # ++++"stock":1
  # +++},
  # +++{
  # ++++"id": 3,
  # ++++"character_id": 0,
  # ++++"name": "汗と涙の結晶",
  # ++++"kana": "あせとなみだのけっしょう",
  # ++++"cost": 0,
  # ++++"stock":20
  # +++}
  # ++]
  # +}
  # 
  # @todo resultの中身作る
  def index
    @result = {} ##FIXME

    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end




  def updates
    logger.debug @character_items_stocks ##FIXME

    respond_to do |format|
      format.json { render json: {} }
    end
  end


  private
    
    def parse_character_items_stocks
      @character_items_stocks = params["character_items_stocks"].inject(Array.new) do |ary, key|
        _character_item_stock = {
          :character_id => key.last["character_id"].to_i,
          :item_id      => key.last["item_id"].to_i,
          :stock        => key.last["stock"].to_i,
        }
        _character_item_stock[:total_cost] = key.last["total_cost"].to_i if _character_item_stock[:stock] > 0
        ary << _character_item_stock
        ary
      end
    end

end
