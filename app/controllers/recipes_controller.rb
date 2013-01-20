# encoding: utf-8

class RecipesController < PageController
  # GET /recipes
  # GET /recipes.json
  def index
    @recipe_list = []
    items = {}
    @item_list = []
    unless params[:recipes].blank?
      params[:recipes].each do |recipe|
        total = 0
        _ingredients = []
        Recipe.find_by_name(recipe).ingredients.each do |ingredient|
          total += ingredient.item.price * ingredient.number
          _ingredients << {:name => ingredient.item.name, :count => ingredient.number, :unitprice => ingredient.item.price }
          if items.has_key?(ingredient.item.kana)
            items[ingredient.item.kana] += ingredient.number
          else
            items[ingredient.item.kana] = ingredient.number
          end
        end
        @recipe_list << {:name => recipe, :price => total, :items => _ingredients}
      end
      items.sort.each do |item|
        @item_list << {:name => Item.find_by_kana(item[0]).name, :count => item[1], :cost => Item.find_by_kana(item[0]).price * value }
      end
    end
      format.html # index.html.erb
      format.json {

        result_hash = {
          :recipe_list => @recipe_list,
          :item_list => @item_list }

        render json: result_hash
      }
    end
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/new
  # GET /recipes/new.json
  def new
    @recipe = Recipe.new
    @ingredients = Array.new(5) {Ingredient.new}
    @items = Item.scoped.map{|item| [item.name, item.id]}.sort
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    @recipe = Recipe.find(params[:id])
    @ingredients = Ingredient.where(:recipe_id => params[:id])
#    if @ingredients.count < 5
#      @ingredients << Array.new(5-@ingredients.count) {Ingredient.new}
#    end
    @items = Item.scoped.map{|item| [item.name, item.id]}.sort
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(params[:recipe])

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render json: @recipe, status: :created, location: @recipe }
      else
        format.html { render action: "new" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /recipes/1
  # PUT /recipes/1.json
  def update
    @recipe = Recipe.find(params[:id])
    respond_to do |format|
      if @recipe.update_attributes(params[:recipe])
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url }
      format.json { head :no_content }
    end
  end
end
