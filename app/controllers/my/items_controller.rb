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
  # @option params [Hash] items_stocks キャラクター毎のアイテム変更情報の配列もどき
  # @option character_items_stocks [Hash] /\d+/ 変更順をキーとするキャラクター毎のアイテム変更情報
  # @option /\d+/ [String] character_id 在庫変更対象のキャラクターID(共用の場合は"0"が入る
  # @option /\d+/ [String] item_id 在庫変更対象のアイテムID
  # @option /\d+/ [String] stock 在庫の変動数
  # @option /\d+/ [String] total_cost 購入時の合計金額（使用時には付かない）
  # @return [String] 変更されたデータの情報を含むJSONオブジェクト（例参照）
  # 
  # @note before_filter :parse_character_items_stocksにより、パラメータは@character_items_stocksに解析され、格納される。
  # @see #parse_character_items_stocks
  #
  # @example 在庫情報更新API
  # +PUT /my/items(.json)
  # +params => {
  # ++"equipments_stocks"=>{
  # +++"add"=>{"0"=>{"recipe_id"=>"1", "cost"=>"430"}},
  # +++"del"=>{"0"=>{"equipment_id"=>"1"}}
  # ++},
  # ++"items_stocks"=>{"0"=>{"item_id"=>"1", "stock"=>"4", "total_cost"=>"30"}, "1"=>{"item_id"=>"2", "stock"=>"-4"}}
  #
  # @note 初級魔法戦士服を作って登録する（コットン草は使い切る）
  # +@my_items_updates = {
  # ++"equipments" => [
  # +++{ "name" => "初級魔法戦士服", "stock" => "1",  "renkin_count" => "0", "total_cost" => "1260" }
  # ++],
  # ++"items" => [
  # +++{ "name" => "あやかしそう",   "stock" => "-3" },
  # +++{ "name" => "コットン草",     "stock" => "-3" }
  # ++]
  # +
  # +#=> {
  # ++"equipments": [
  # +++{ "name": "初級魔法戦士服", "stock": 1, "renkin_count": 0, "cost": 1260 }
  # ++],
  # ++"items": [
  # +++{ "name": "あやかしそう",   "stock": 7, "cost": 290 },
  # +++{ "name": "コットン草",     "stock": 0, "cost": 120 }
  # ++]
  # +}
  #
  # @note ぬすっとの服＋１にしゅび力+2を付けて＋２にして登録する
  # +@my_items_updates = {
  # ++"equipments" => [
  # +++{ "name" => "ぬすっとの服", "stock" => "-1", "renkin_count" => "1",
  # "cost" => "700" },
  # +++{ "name" => "ぬすっとの服", "stock" => "1",  "renkin_count" => "2", "cost" => "1000" }
  # ++],
  # ++"items" => [
  # +++{ "name" => "小さなこうら", "stock" => "-1" },
  # +++{ "name" => "ようせいの粉", "stock" => "-1" }
  # ++]
  # +
  # +#=> {
  # ++"equipments": [
  # +++{ "name": "ぬすっとの服", "renkin_count": 0, "cost": 1260 }
  # ++],
  # ++"items": [
  # +++{ "name": "あやかしそう", "stock": 7, "cost": 290 },
  # +++{ "name": "コットン草",   "stock": 0, "cost": 0   }
  # ++]
  # +}
  #
  # +@my_items_updates = [
  # ++{
  # +++"name"       => "初級魔法戦士服",
  # +++"stock"      => "-1",
  # +++"total_cost" => "-960"
  # ++},
  # ++{
  # +++"name"       => "小さなこうら",
  # +++"stock"      => "-1",
  # +++"total_cost" => "-250"
  # ++},
  # ++{
  # +++"name"       => "ようせいの粉",
  # +++"stock"      => "-1",
  # +++"total_cost" => "-100"
  # ++},
  # ++{
  # +++"name"       => "銀の錬金ツボ",
  # +++"total_cost" => "-37"
  # ++}
  # +]
  # +
  # +#=> {
  # ++"items": [
  # +++{
  # ++++"name": "あやかしそう",
  # ++++"stock": 7,
  # ++++"cost": 290
  # +++},
  # +++{
  # ++++"name": "コットン草",
  # ++++"stock": 0,
  # ++++"cost": 0
  # +++},
  # +++{
  # +++}
  # ++],
  # ++"equipments": [
  # +++{
  # ++++"name": "初級魔法戦士服",
  # ++++"stock": 4,
  # ++++"total_cost": 960
  # +++}
  # ++]
  # +}






  # +}
  # +
  # +レスポンス
  # +{
  # ++"items": [
  # +++{
  # ++++"id": 1,
  # ++++"character_id": 2,
  # ++++"cost": 30,
  # ++++"stock":20
  # +++},
  # +++{
  # ++++"id": 2,
  # ++++"character_id": 1,
  # ++++"cost": 0,
  # ++++"stock":0
  # +++}
  # ++]
  # +}
  #
  # @todo parse_character_items_stocksが処理した@character_items_stocksを、ごにょごにょして@resultに入れる 
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
    

    ##FIXME @character_items_stocksを、ごにょごにょして@resultに入れる 
    logger.debug @character_items_stocks
    @result = {"items"=>[{"id"=>1, "character_id"=>2, "cost"=>30, "stock"=>0}, {"id"=>3, "character_id"=>0, "cost"=>100, "stock"=>20}]}
    ######
=end


    @result = {}
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
