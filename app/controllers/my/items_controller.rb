# encoding: utf-8


# 在庫管理用コントローラ
#
# @author tk.hamaguchi@gmail.com
# @since 2.0.0
#
class My::ItemsController < MyController

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
    @characters = []
    mychar.each do |char|
      @characters << {:id => char.id, :name => char.char_name }
    end
    @items = []
    resources.each do |item|
      @items << {:id => item.item_id, :character_id => item.character_id, :name => Item.find(item.item_id).name,  :kana => Item.find(item.item_id).kana, :cost => item.average_cost, :stock => item.stock }
    end
    @result = {} ##FIXME
    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end

  private
  def resources
    resources = Inventory.where(:user_id => current_user.id)
  end

  def mychar
    mychar = Character.where(:user_id => current_user.id)
  end
end
