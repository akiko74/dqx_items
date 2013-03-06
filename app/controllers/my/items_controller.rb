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
    @characters = []
    mychar.each do |char|
      @characters << {:id => char.id, :name => char.char_name }
    end
    @items = []
    resources.each do |item|
      @items << {:id => item.item_id, :character_id => item.character_id, :name => Item.find(item.item_id).name,  :kana => Item.find(item.item_id).kana, :cost => item.average_cost, :stock => item.stock }
    end
    @result = {:characters => @characters, :items => @items}

    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end



  # 在庫情報更新
  #
  # @param [Hash] params リクエストパラメータ
  # @option params [Hash] character_items_stocks キャラクター毎のアイテム変更情報の配列もどき
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
  # +params => {"character_items_stocks"=>{"0"=>{"character_id"=>"2", "item_id"=>"1", "stock"=>"4", "total_cost"=>"30"}, "1"=>{"character_id"=>"1", "item_id"=>"2", "stock"=>"-4"}}}
  # +
  # +
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
    @result = {}

    ##FIXME @character_items_stocksを、ごにょごにょして@resultに入れる 
    logger.debug @character_items_stocks
    @result = {"items"=>[{"id"=>1, "character_id"=>2, "cost"=>30, "stock"=>0}, {"id"=>3, "character_id"=>0, "cost"=>100, "stock"=>20}]}
    ######

    respond_to do |format|
      format.json { render json: @result }
    end
  end


  private
    
    # リクエストパラメータからキャラクター毎の在庫変更情報を抽出して@character_items_stocksに格納する
    # 
    # @example 在庫追加情報を含むパラメータの処理
    # +Parameters:
    # ++params = {
    # +++"character_items_stocks" => {
    # ++++"0" => { "character_id" => "2", "item_id" => "1", "stock" => "4", "total_cost" => "30" }
    # +++}
    # ++}
    # +
    # +Result:
    # ++@character_items_stocks = [
    # +++{
    # ++++:character_id => 2,
    # ++++:item_id      => 1,
    # ++++:stock        => 4,
    # ++++:total_cost   => 30
    # +++}
    # ++]
    # 
    # @example 在庫削減情報を含むパラメータの処理
    # +Parameters:
    # ++params = {
    # +++"character_items_stocks" => {
    # ++++"0" => { "character_id" => "1", "item_id" => "2", "stock" => "-4" }
    # +++}
    # ++}
    # +
    # +result:
    # ++@character_items_stocks = [
    # +++{
    # ++++:character_id => 1,
    # ++++:item_id      => 2,
    # ++++:stock        => -4
    # +++}
    # ++]
    # 
    # @example 在庫追加情報と削減情報の両方を含むパラメータの処理
    # +Parameters:
    # ++params = {
    # +++"character_items_stocks" => {
    # ++++"0" => { "character_id" => "2", "item_id" => "10", "stock" => "4", "total_cost" => "30" },
    # ++++"1" => { "character_id" => "2", "item_id" => "2", "stock" => "-4" },
    # ++++"2" => { "character_id" => "2", "item_id" => "5", "stock" => "1", "total_cost" => "200" },
    # ++++"3" => { "character_id" => "2", "item_id" => "7", "stock" => "-52" },
    # ++++"4" => { "character_id" => "2", "item_id" => "15", "stock" => "-7" }
    # +++}
    # ++}
    # +
    # +Result:
    # ++@character_items_stocks = [
    # +++{
    # ++++:character_id => 2,
    # ++++:item_id      => 10,
    # ++++:stock        => 4,
    # ++++:total_cost   => 30
    # +++},
    # +++{
    # ++++:character_id => 2,
    # ++++:item_id      => 2,
    # ++++:stock        => -4
    # +++},
    # +++{
    # ++++:character_id => 2,
    # ++++:item_id      => 5,
    # ++++:stock        => 1,
    # ++++:total_cost   => 200
    # +++},
    # +++{
    # ++++:character_id => 2,
    # ++++:item_id      => 7,
    # ++++:stock        => -52
    # +++},
    # +++{
    # ++++:character_id => 2,
    # ++++:item_id      => 15,
    # ++++:stock        => -7
    # +++}
    # 
    # @example 複数のキャラクターにまたがる処理
    # +Parameters:
    # ++params = {
    # +++"character_items_stocks" => {
    # ++++"0" => { "character_id" => "1", "item_id" => "2", "stock" => "4", "total_cost" => "0" },
    # ++++"1" => { "character_id" => "2", "item_id" => "2", "stock" => "-4" }
    # +++}
    # ++}
    # +
    # +Result:
    # ++@character_items_stocks = [
    # +++{
    # ++++:character_id => 1,
    # ++++:item_id      => 2,
    # ++++:stock        => 4,
    # ++++:total_cost   => 0
    # +++},
    # +++{
    # ++++:character_id => 2,
    # ++++:item_id      => 2,
    # ++++:stock        => -4
    # +++}
    # 
    def parse_character_items_stocks
      @character_items_stocks = params["character_items_stocks"].inject(Array.new) do |ary, key|
        _character_item_stock = {
          :character_id => key.last["character_id"].to_i,
          :item_id      => key.last["item_id"].to_i,
          :stock        => key.last["stock"].to_i,
        }
        _character_item_stock[:total_cost] = key.last["total_cost"].to_i if _character_item_stock[:stock] > 0
        ary[key.first.to_i] = _character_item_stock
        ary
      end
    end

    def resources
      resources = Inventory.where(:user_id => current_user.id)
    end

    def mychar
      mychar = Character.where(:user_id => current_user.id)
    end
end
