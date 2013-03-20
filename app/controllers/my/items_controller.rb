# encoding: utf-8


# 在庫管理用コントローラ
#
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
  # ++++"recipe_name": "どうのつるぎ",
  # ++++"recipe_kana": "どうのつるぎ",
  # ++++"cost": 320,
  # ++++"renkin_count": 1
  # +++},
  # +++{
  # ++++"recipe_name": "銅のさいほう針",
  # ++++"recipe_kana": "どうのさいほうばり",
  # ++++"cost": 20,
  # ++++"renkin_count": 0,
  # +++}
  # ++],
  # ++"items": [
  # +++{
  # ++++"name": "どうのこうせき",
  # ++++"kana": "どうのこうせき",
  # ++++"cost": 30,
  # ++++"stock":2
  # +++},
  # +++{
  # ++++"name": "じょうぶな枝",
  # ++++"kana": "じょうぶなえだ",
  # ++++"cost": 40,
  # ++++"stock":1
  # +++},
  # +++{
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
    @items = []
    resources.each do |item|
      @items << {:id => item.item_id, :name => Item.find(item.item_id).name,  :kana => Item.find(item.item_id).kana, :cost => item.average_cost, :stock => item.stock }
    end
    @result = {:uid => @uid, :characters => @characters, :items => @items}
=end
    @result = { uid: @uid, equipments: [], items: [] }

    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end


  # 在庫情報更新
  #
  # @param [Hash] params リクエストパラメータ
  # @option params [Hash] equipments 装備品の変更情報を含んだ配列もどき
  # @option equipments [Hash] /\d+/ 変更順をキーとする装備品の在庫変更情報
  # @option /\d+/ [String] name 変更対象の装備品名
  # @option /\d+/ [String] stock 在庫の変動(1|-1)
  # @option /\d+/ [String] renkin_count 錬金済回数
  # @option /\d+/ [String] cost 装備品のコスト
  # @option params [Hash] items アイテムの変更情報を含んだ配列もどき
  # @option items [Hash] /\d+/ 変更順をキーとするアイテムの在庫変更情報
  # @option /\d+/ [String] name 変更対象のアイテム名
  # @option /\d+/ [String] stock 在庫の変動数
  # @option /\d+/ [String] cost アイテムのコスト
  # @return [String] 変更されたデータの情報を含むJSONオブジェクト（例参照）
  # 
  # @note before_filter :parse_equipments_items_jsonにより、パラメータは@requested_equipments_itemsに解析され、格納される。
  # @see #parse_equipments_items_json
  #
  # @todo parse_equipments_items_jsonが処理した@requested_equipments_itemsを、ごにょごにょして@resultに入れる 
  #
  # @example sd1 裁縫職人が初級魔法戦士服を作って登録する。コットン草は使い切る。
  # +RequestParams:
  # ++{
  # +++"equipments" => {
  # ++++"0" => { "name" => "初級魔法戦士服", "stock" => "1", "renkin_count" => "0", "cost" => "1260" }
  # +++},
  # +++"items" => {
  # ++++"0" => { "name" => "あやかしそう", "stock" => "-3" },
  # ++++"1" => { "name" => "コットン草",   "stock" => "-3" }
  # +++}
  # ++}
  # +
  # +Response:
  # ++{
  # +++"equipments": [
  # ++++{ "name": "初級魔法戦士服", "stock": 1, "renkin_count": 0, "cost": 1260 }
  # +++],
  # +++"items": [
  # ++++{ "name": "あやかしそう", "stock": 7, "cost": 290 },
  # ++++{ "name": "コットン草", "stock": 0, "cost": 120 }
  # +++]
  # ++}
  #
  # @example sd2 ツボ職人がぬすっとの服＋１にしゅび力＋２の効果を付けて登録する。
  # +RequestParams:
  # ++{
  # +++"equipments" => {
  # ++++"0" => { "name" => "ぬすっとの服", "stock" => "-1", "renkin_count" => "1", cost" => "700" },
  # ++++"1" => { "name" => "ぬすっとの服", "stock" => "1",  "renkin_count" => "2", "cost" => "1000" }
  # +++},
  # +++"items" => {
  # ++++"0" => { "name" => "小さなこうら", "stock" => "-1" },
  # ++++"1" => { "name" => "ようせいの粉", "stock" => "-1" }
  # +++}
  # ++}
  # +
  # +Response:
  # ++{
  # +++"equipments": [
  # ++++{ "name": "ぬすっとの服", "stock": 0, "renkin_count": 1, cost": 700 },
  # ++++{ "name": "ぬすっとの服", "stock": 1,  "renkin_count": 2, "cost": 1000 }
  # +++],
  # +++"items": [
  # ++++{ "name": "小さなこうら", "stock": 2, "cost": 250  },
  # ++++{ "name": "ようせいの粉", "stock": 3, "cost": 100  }
  # +++]
  # ++}
  #
  #
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

    #input sample:
    #{:equipments => [{ :name => "初級魔法戦士服", :stock => 1, :renkin_count => 0, :cost => 1260 }],
    #              :items => [{ :name => "あやかしそう", :stock => -3 },{ :name => "コットン草", :stock => -3 }]}
    @equipment_result = []
    @item_result =[]
    @equipments = @requested_equipments_items[:equipments]
      @equipments.each do |equipment|
        recipe = Recipe.find_by_name(equipment[:name])
        case
          when equipment[:stock] == -1
            @equipment_result << [my_equipments.where("recipe_id = ? AND renkin_count = ? AND total_cost = ?", recipe.id, equipment[:renkin_count], equipment[:cost]).first.destroy, equipment[:name], 0 ]
          when equipment[:stock] == 1
            @equipment_result << [my_equipments.create(:recipe_id => recipe.id, :renkin_count => equipment[:renkin_count], :cost => equipment[:cost]), equipment[:name], recipe.usage_count, 1 ]
        end
      end
    @inventories = @requested_equipments_items[:items]
       @inventories.each do |inventory|
         item_id = Item.find_by_name(inventory[:name]).id
           if resources.where(:item_id => item_id).present?
             my_inventory = resources.find_by_item_id(item_id)
             my_inventory.stock += inventory[:stock]
             my_inventory.total_cost += inventory[:cost]
               if my_inventory.stock <= 0
                 my_inventory.stock = 0
                 my_inventory.total_cost = 0
                 @item_result << [my_inventory.destroy, inventory[:name]]
               else
                 my_inventory.save
                 @item_result << [my_inventory, inventory[:name]]
               end
           else
             @item_result << resources.create(:item_id => item_id, :total_cost => inventory[:cost], :stock => inventory[:stock]) if inventory[:stock] > 0
           end
       end
      equipment_array = []
      @equipment_result.each do |equipment|
        equipment_array << {:name => equipment[1], :stock => equipment[3], :renkin_count => equipment[0].renkin_count, :cost => (equipment[0].cost/equipment[2] rescue 0)}
      end
      item_array = []
      @item_result.each do |item|
        item_array << {:name => item[1], :stock => item[0].stock, :cost => (item[0].total_cost/item[0].stock rescue 0)}
      end

    ##FIXME @requested_equipments_itemsを、ごにょごにょして@resultに入れる 
    logger.debug @requested_equipments_items
    @result = {:equipments => equipment_array, :items => item_array }
    ######

    respond_to do |format|
      format.json { render json: @result }
    end
  end


  private
    
    # リクエストパラメータを最適化し、@requested_equipments_itemsへ格納する
    # 
    # @param [Hash] params リクエストパラメータ
    # @option params [Hash] equipments 装備品の変更情報を含んだ配列もどき
    # @option equipments [Hash] /\d+/ 変更順をキーとする装備品の在庫変更情報
    # @option /\d+/ [String] name 変更対象の装備品名
    # @option /\d+/ [String] stock 在庫の変動(1|-1)
    # @option /\d+/ [String] renkin_count 錬金済回数
    # @option /\d+/ [String] cost 装備品のコスト
    # @option params [Hash] items アイテムの変更情報を含んだ配列もどき
    # @option items [Hash] /\d+/ 変更順をキーとするアイテムの在庫変更情報
    # @option /\d+/ [String] name 変更対象のアイテム名
    # @option /\d+/ [String] stock 在庫の変動数
    # @option /\d+/ [String] cost アイテムのコスト
    # @return [Hash] 最適化されたHashオブジェクト（例参照）
    # 
    # @example sd1 裁縫職人が初級魔法戦士服を作って登録する。コットン草は使い切る。
    # +RequestParams:
    # ++{
    # +++"equipments" => {
    # ++++"0" => { "name" => "初級魔法戦士服", "stock" => "1", "renkin_count" => "0", "cost" => "1260" }
    # +++},
    # +++"items" => {
    # ++++"0" => { "name" => "あやかしそう", "stock" => "-3" },
    # ++++"1" => { "name" => "コットン草",   "stock" => "-3" }
    # +++}
    # ++}
    # +
    # +Result:
    # ++@requested_equipments_items = {
    # +++equipments: [
    # ++++{ name: "初級魔法戦士服", stock: 1, renkin_count: 0, cost: 1260 }
    # +++],
    # +++items: [
    # ++++{ name: "あやかしそう", stock: -3 },
    # ++++{ name: "コットン草", stock: -3 }
    # +++]
    # ++}
    #
    # @example sd2 ツボ職人がぬすっとの服＋１にしゅび力＋２の効果を付けて登録する。
    # +RequestParams:
    # ++{
    # +++"equipments" => {
    # ++++"0" => { "name" => "ぬすっとの服", "stock" => "-1", "renkin_count" => "1", cost" => "700" },
    # ++++"1" => { "name" => "ぬすっとの服", "stock" => "1",  "renkin_count" => "2", "cost" => "1000" }
    # +++},
    # +++"items" => {
    # ++++"0" => { "name" => "小さなこうら", "stock" => "-1" },
    # ++++"1" => { "name" => "ようせいの粉", "stock" => "-1" }
    # +++}
    # ++}
    # +
    # +Result:
    # ++@requested_equipments_items = {
    # +++equipments: [
    # ++++{ name: "ぬすっとの服", stock: -1, renkin_count: 1, cost: 700 },
    # ++++{ name: "ぬすっとの服", stock: 1,  renkin_count: 2, cost: 1000 }
    # +++],
    # +++items: [
    # ++++{ name: "小さなこうら", stock: -1 },
    # ++++{ name: "ようせいの粉", stock: -1 }
    # +++]
    # ++}
    #
    # 
    def parse_equipments_items_json
      @requested_equipments_items ||= begin
        _equipments_items_hash = ['items','equipments'].each_with_object({}) { |key, hash|
          next unless params[key].kind_of? Hash
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

    def my_equipments
      my_equipmnets = Equipment.where(:user_id => current_user.id)
    end
end
