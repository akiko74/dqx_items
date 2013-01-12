# encoding: utf-8

class RecipesController < ApplicationController
  # GET /recipes
  # GET /recipes.json
  def index
    @recipe_list = []
    unless params[:recipes].blank?
      params[:recipes].each do |recipe|
        total = 0
        Recipe.find_by_name(recipe).ingredients.each do |ingredient|
          total += ingredient.item.price * ingredient.number
        end
        @recipe_list << {:name => recipe, :price => total}
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {

        # TODO 計算結果に置き換える
        result_hash = {
          :recipe_list => @recipe_list,
          :item_list => [
            {
              :name  => "どうのこうせき",
              :count => "3"
            },
            {
              :name  => "麻の糸",
              :count => "3"
            }
          ]
        }
        # ここまで置き換える

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
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @recipe }
    end
  end

  # GET /recipes/1/edit
  def edit
    @recipe = Recipe.find(params[:id])
    @ingredients = Ingredient.where(:recipe_id => params[:id])
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
