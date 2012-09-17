# encoding: utf-8


require 'spec_helper'


describe RecipesController do

  context "#index" do

    subject { get :index }
    let!(:recipes) {
      (5..10).to_a.sample.times.inject([]) do |ary,i|
        ary << FactoryGirl.create(:recipe)
        ary
      end
    }
    #let(:admin) { FactoryGirl.create(:admin) }

    context 'with registed admin' do
      #before { sign_in admin }
      it_should_behave_like 'the Request that is returned "Recipe list Page"'
      context '@recipes' do
        subject {
          get :index 
          assigns(:recipes)
        }
        it "should assigns" do
          should == recipes
        end
      end
    end

    context 'with nobody' do
      it_should_behave_like 'the Request that is returned "Recipe list Page"'
      context '@recipes' do
        subject {
          get :index 
          assigns(:recipes)
        }
        it "should assigns" do
          should == recipes
        end
      end
    end

  end


  context "#show" do

    subject { get :show, :id => recipe.id }
    let(:recipe) { FactoryGirl.create(:recipe) }

    context 'with registed admin' do
      #before { sign_in admin }
      it_should_behave_like 'the Request that is returned "Recipe Page"'
      context '@recipe' do
        subject {
          get :show, :id => recipe.id
          assigns(:recipe)
        }
        it "should assigns" do
          should == recipe
        end
      end
    end

    context 'with nobody' do
      it_should_behave_like 'the Request that is returned "Recipe Page"'
      context '@recipe' do
        subject {
          get :show, :id => recipe.id
          assigns(:recipe)
        }
        it "should assigns" do
          should == recipe
        end
      end
    end

  end




  # This should return the minimal set of attributes required to create a valid
  # Recipe. As you add validations to Recipe, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RecipesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET new" do
    it "assigns a new recipe as @recipe" do
      get :new, {}, valid_session
      assigns(:recipe).should be_a_new(Recipe)
    end
  end

  describe "GET edit" do
    it "assigns the requested recipe as @recipe" do
      recipe = Recipe.create! valid_attributes
      get :edit, {:id => recipe.to_param}, valid_session
      assigns(:recipe).should eq(recipe)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Recipe" do
        expect {
          post :create, {:recipe => valid_attributes}, valid_session
        }.to change(Recipe, :count).by(1)
      end

      it "assigns a newly created recipe as @recipe" do
        post :create, {:recipe => valid_attributes}, valid_session
        assigns(:recipe).should be_a(Recipe)
        assigns(:recipe).should be_persisted
      end

      it "redirects to the created recipe" do
        post :create, {:recipe => valid_attributes}, valid_session
        response.should redirect_to(Recipe.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved recipe as @recipe" do
        # Trigger the behavior that occurs when invalid params are submitted
        Recipe.any_instance.stub(:save).and_return(false)
        post :create, {:recipe => {}}, valid_session
        assigns(:recipe).should be_a_new(Recipe)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Recipe.any_instance.stub(:save).and_return(false)
        post :create, {:recipe => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested recipe" do
        recipe = Recipe.create! valid_attributes
        # Assuming there are no other recipes in the database, this
        # specifies that the Recipe created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Recipe.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => recipe.to_param, :recipe => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested recipe as @recipe" do
        recipe = Recipe.create! valid_attributes
        put :update, {:id => recipe.to_param, :recipe => valid_attributes}, valid_session
        assigns(:recipe).should eq(recipe)
      end

      it "redirects to the recipe" do
        recipe = Recipe.create! valid_attributes
        put :update, {:id => recipe.to_param, :recipe => valid_attributes}, valid_session
        response.should redirect_to(recipe)
      end
    end

    describe "with invalid params" do
      it "assigns the recipe as @recipe" do
        recipe = Recipe.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Recipe.any_instance.stub(:save).and_return(false)
        put :update, {:id => recipe.to_param, :recipe => {}}, valid_session
        assigns(:recipe).should eq(recipe)
      end

      it "re-renders the 'edit' template" do
        recipe = Recipe.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Recipe.any_instance.stub(:save).and_return(false)
        put :update, {:id => recipe.to_param, :recipe => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested recipe" do
      recipe = Recipe.create! valid_attributes
      expect {
        delete :destroy, {:id => recipe.to_param}, valid_session
      }.to change(Recipe, :count).by(-1)
    end

    it "redirects to the recipes list" do
      recipe = Recipe.create! valid_attributes
      delete :destroy, {:id => recipe.to_param}, valid_session
      response.should redirect_to(recipes_url)
    end
  end

end
