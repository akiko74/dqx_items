class My::CharactersController < MyController
  def index
    @characters = resources
  end

  def new
    @character = resources.new(params[:character])
  end

  def create
    @character = resources.new(params[:character])

    respond_to do |format|
      if @character.save
        format.html { redirect_to my_characters_path, notice: 'Character was successfully created.' }
        format.json { render json: @character, status: :created, location: @character }
      else
        format.html { render action: "new" }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @character = resources.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @character }
    end
  end

  def edit
    @character = resources.find(params[:id])
  end

  def update
    @character = resources.find(params[:id])

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to my_characters_path, notice: 'Character was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @character.errors, status: :unproccessable_entity }
      end
    end
  end

  def destroy
    @character = resources.find(params[:id])
    @character.destroy

    respond_to do |format|
      format.html { redirect_to my_characters_path }
      format.json { head :no_content }
    end
  end

  private

  def resources
    Character.where(:user_id => current_user.id)
  end
end
