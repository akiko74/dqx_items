# encoding: utf-8


require 'spec_helper'


describe RecipesController do

  let(:admin) { FactoryGirl.create(:admin) }

  context "#index" do

    subject { get :index }
    let!(:recipes) {
      (5..10).to_a.sample.times.inject([]) do |ary,i|
        ary << FactoryGirl.create(:recipe)
        ary
      end
    }


    context 'with registed admin' do
      before { sign_in admin }
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
      before { sign_in admin }
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


  context "#new" do

    subject { get :new }

    context 'with registed admin' do
      before { sign_in admin }
      it_should_behave_like 'the Request that is returned "Recipe regist Page"'
      context '@recipe' do
        subject {
          get :new
          assigns(:recipe)
        }
        it "should assigns" do
          should be_a_new(Recipe)
        end
      end
    end

    context 'with nobody' do
      it { expect { subject }.to raise_error ActionController::RoutingError }
    end

  end


  context "#edit" do

    subject { get :edit, :id => recipe.id }
    let(:recipe) { FactoryGirl.create(:recipe) }

    context 'with registed admin' do
      before { sign_in admin }
      it_should_behave_like 'the Request that is returned "Recipe edit Page"'
      context '@recipe' do
        subject {
          get :edit, :id => recipe.id
          assigns(:recipe)
        }
        it "should assigns" do
          should == recipe
        end
      end
    end

    context 'with nobody' do
      it { expect { subject }.to raise_error ActionController::RoutingError }
    end

  end


  context "#create" do
    subject { post :create, params }
    let(:params) { FactoryGirl.attributes_for(:recipe) }

    context 'with registed admin' do
      before { sign_in admin }

      context "with valid params" do
        it { expect { subject }.to change(Recipe, :count).by(1) }
        it_should_behave_like 'the Request that is redirected to "Recipe Page"'
        context '@recipe' do
          subject {
            post :create, params
            assigns(:recipe)
          }
          it { should be_a Recipe }
          it { should be_persisted }
        end
      end

      context "with invalid params" do
        before { Recipe.any_instance.stub(:save).and_return(false) }        
        it_should_behave_like 'the Request that is returned "Recipe regist Page"'
        context '@recipe' do
          subject {
            post :create, params
            assigns(:recipe)
          }
          it { should be_a_new(Recipe) }
        end
      end

    end
    context 'with nobody' do
      it { expect { subject }.to raise_error ActionController::RoutingError }
    end
  end


  context "#update" do
    subject { put :update, params.merge(:id => recipe.id) }
    let(:recipe) { FactoryGirl.create(:recipe) }
    let(:params) { FactoryGirl.attributes_for(:recipe) }

    context 'with registed admin' do
      before { sign_in admin }

      context "with valid params" do
        it_should_behave_like 'the Request that is redirected to "Recipe Page"'
        context '@recipe' do
          subject {
            put :update, params.merge(:id => recipe.id)
            assigns(:recipe).attributes
          }
          it { should_not == recipe  }
        end
      end

      context "with invalid params" do
        before { Recipe.any_instance.stub(:save).and_return(false) }        
        it_should_behave_like 'the Request that is returned "Recipe edit Page"'
        context '@recipe' do
          subject {
            put :update, params.merge(:id => recipe.id)
            assigns(:recipe)
          }
          it { should == recipe }
        end
      end

    end
    context 'with nobody' do
      it { expect { subject }.to raise_error ActionController::RoutingError }
    end
  end


  context "#destroy" do
    subject { delete :destroy, :id => recipe.id }
    let!(:recipe) { FactoryGirl.create(:recipe) }

    context 'with registed admin' do
      before { sign_in admin }

      context "with valid params" do
        it_should_behave_like 'the Request that is redirected to "Recipe list Page"'
        it { expect { subject }.to change(Recipe, :count).by(-1) }
      end

      context "with invalid params" do
        before { Recipe.any_instance.stub(:destroy).and_return(false) }        
        it_should_behave_like 'the Request that is redirected to "Recipe list Page"'
        it { expect { subject }.to_not change(Recipe, :count) }
      end

    end
    context 'with nobody' do
      it { expect { subject }.to raise_error ActionController::RoutingError }
    end
  end

end

