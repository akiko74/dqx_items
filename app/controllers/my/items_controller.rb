# encoding: utf-8


# 在庫管理用コントローラ
#
# @author tk.hamaguchi@gmail.com
# @since 2.0.0
#
class My::ItemsController < MyController

  before_filter :parse_equipments_items_json, :only => [:updates]

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
  # ++"uid": "547118FF172E4BFD9D3881A83EA79B62",
  # ++"equipments": [
  # +++{
  # ++++"recipe_id": 1,
  # ++++"recipe_name": "どうのつるぎ",
  # ++++"recipe_kana": "どうのつるぎ",
  # ++++"cost": 320,
  # ++++"renkin_count": 1
  # +++},
  # +++{
  # ++++"recipe_id": 12,
  # ++++"recipe_name": "銅のさいほう針",
  # ++++"recipe_kana": "どうのさいほうばり",
  # ++++"cost": 20,
  # ++++"renkin_count": 0,
  # +++}
  # ++],
  # ++"items": [
  # +++{
  # ++++"id": 1,
  # ++++"name": "どうのこうせき",
  # ++++"kana": "どうのこうせき",
  # ++++"cost": 30,
  # ++++"stock":2
  # +++},
  # +++{
  # ++++"id": 2,
  # ++++"name": "じょうぶな枝",
  # ++++"kana": "じょうぶなえだ",
  # ++++"cost": 40,
  # ++++"stock":1
  # +++},
  # +++{
  # ++++"id": 3,
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

    @uid = Digest::SHA1.hexdigest("user-#{current_user.id}")

=begin
    @characters = []
    mychar.each do |char|
      @characters << {:id => char.id, :name => char.char_name }
    end
    @items = []
    resources.each do |item|
      @items << {:id => item.item_id, :character_id => item.character_id, :name => Item.find(item.item_id).name,  :kana => Item.find(item.item_id).kana, :cost => item.average_cost, :stock => item.stock }
    end
    @result = {:uid => @uid, :characters => @characters, :items => @items}
=end
    @result = {}

    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end


  # 在庫情報更新
  #
  # @param [Hash] params リクエストパラメータ
  # @return [String] 変更されたデータの情報を含むJSONオブジェクト（例参照）
  # 
  # @note before_filter :parse_equipments_items_jsonにより、パラメータは@requested_equipments_itemsに解析され、格納される。
  # @see #parse_equipments_items_json
  #
  # @todo parse_equipments_items_jsonが処理した@requested_equipments_itemsを、ごにょごにょして@resultに入れる 
  def updates


    ##やること##
    ##更新対象のitem_id,average_cost,stockを取得
    ##更新対象のレコードを user_id && item_id で特定
    ##在庫情報と追加情報をマージ
    ## => params[:stock] > 0の場合
    #       # => new_average_cost = param[total_cost] + Inventory[average_cost * stock] / params[stock]+Inventory[stock]
    # 共通
    ## => new_stock = params[stock] + Inventory[stock]
    #  => new_stock < 0 の場合、delete_record && return 0 とする
    # New
    ##更新対象がなかった場合はnewを呼ぶ
    #
=begin
    @character_items_stocks.each do |item|
       inventories = Inventory.where("user_id = ? AND item_id = ?", current_user.id, item[:item_id])
       if inventories.present?
         inventory = Inventory.find(inventories.first.id)
           if item[:stock] >= 0
           inventory.average_cost = (inventory.average_cost * inventory.stock + item[:total_cost])/(inventory.stock + item[:stock])
           end
           inventory.stock = inventory.stock + item[:stock]
       else
         inventory = Inventory.new(:user_id => current_user.id, :item_id => item[:item_id], :stock => item[:stock], :average_cost => (item[:total_cost]/item[:stock]))
       end
         inventory.save
    end
    
=end

    ##FIXME @requested_equipments_itemsを、ごにょごにょして@resultに入れる 
    logger.debug @requested_equipments_items
    @result = {}
    ######

    respond_to do |format|
      format.json { render json: @result }
    end
  end


  private
    
    # リクエストパラメータからキャラクター毎の在庫変更情報を抽出して@character_items_stocksに格納する
    # 
    # 
    def parse_equipments_items_json
      @requested_equipments_items ||= begin
        _equipments_items_hash = params.keys.each_with_object({}) { |key, hash|
          hash[key.to_sym] = Array.new
          params[key].each do |no,value|
            hash[key.to_sym][no.to_i] = value.each_with_object({}) { |set,hash|
              hash[set[0].to_sym] = set[0] == "name" ? set[1] : set[1].to_i
            }
          end
        }
      end
    end

    def resources
      resources = Inventory.where(:user_id => current_user.id)
    end
end
