# encoding: utf-8


# 在庫管理用コントローラ
#
# @since 2.0.0
#
class My::ItemsController < MyController
  include My::ItemsHelper

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

    @items = []
    resources.each do |item|
      i = Item.find(item.item_id)
      @items << {:name => i.name,  :kana => i.kana, :stock => item.stock, :cost => (item.total_cost/item.stock rescue 0)}
    end
    @equipments = []
    my_equipments.each do |equipment|
      recipe = Recipe.find(equipment.recipe_id)
      @equipments << {:recipe_name => recipe.name, :recipe_kana => recipe.kana, :cost => equipment.cost, :renkin_count => equipment.renkin_count }
    end

    @result = { uid: @uid, equipments: @equipments, items: @items }

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

    ActiveRecord::Base.transaction do

    #input sample:
    #{:equipments => [{ :name => "麻の服", :stock => 1, :renkin_count => 0, :cost => 1260 }],
    # :items => [{ :name => "あやかしそう", :stock => 3, :cost => 300 },{ :name => "コットン草", :stock => 3, :cost => 600 }]}
    #
    #

    equipment_result = []
    if @requested_equipments_items[:equipments].present?
      @requested_equipments_items[:equipments].each do |equipment|
        case equipment[:stock]
          when 1
            my_equipments.create(:recipe_id => Recipe.find_by_name(equipment[:name]).id, 
                                 :cost => equipment[:cost],
                                 :renkin_count => equipment[:renkin_count])
          when -1
            my_equipments.find_by_recipe_id_and_cost_and_renkin_count(Recipe.find_by_name(equipment[:name]),equipment[:cost], equipment[:renkin_count]).destroy
            equipment[:stock] = 0
        end
        equipment_result << equipment
      end
    end

    item_result = []
    inventories = partialize_items(@requested_equipments_items[:items])
    if inventories.key? :add
      inventories[:add].each do |inventory|
        add_item = resources.where(:item_id => inventory[:item_id]).first_or_create
        add_item.stock += inventory[:stock]
        add_item.total_cost += inventory[:cost]
        add_item.save
      end
    end
    if inventories.key? :delete
      inventories[:delete].each do |inventory|
        delete_item = resources.where(:item_id => inventory[:item_id]).first
        next unless delete_item.present?
        delete_item.total_cost += (inventory[:stock] * (delete_item.total_cost / delete_item.stock))
        delete_item.stock += inventory[:stock]
          if delete_item.stock <= 0
            delete_item.destroy
          else delete_item.save
        end
      end
    end

    if inventories.key?(:delete) && inventories.key?(:add)
      (inventories[:add]+inventories[:delete]).each do |inventory|
        item = resources.where(:item_id => inventory[:item_id]).first
        if item.present?
          item_result << {name: inventory[:name], stock: item.stock, cost: (item.total_cost / item.stock rescue 0) }
        else
          item_result << {name: inventory[:name], stock: 0, cost: 0}
        end
      end
    end

    logger.debug @requested_equipments_items
    @result = {:equipments => equipment_result, :items => item_result }

    respond_to do |format|
      format.json { render json: @result }
    end
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
      my_equipments = Equipment.where(:user_id => current_user.id)
    end
end
