# encoding: utf-8


require 'spec_helper'


describe My::ItemsController do

  include_context 'http-request'
  it { should respond_to :index }

  let(:current_user) { FactoryGirl.create(:user) }
  before {
    controller.stub!(:current_user).and_return(current_user)
    controller.stub!(:authenticate_user!).and_return(true)
    controller.stub!(:parse_equipments_items_json).and_return({})
  }

  context "#index" do
    let(:req) { get :index, params }
    context "response" do
      before { req }
      subject { response }
      it_behaves_like 'the Request that is returned "HTTP OK"'
    end
    context "@result" do
      before { req }
      subject { assigns(:result) }
      pending "そのうち書く"
    end
    context "request" do
      subject { req }
      it "should call controller#authenticate_user!" do
        controller.should_receive(:authenticate_user!)
        subject
      end
      it "should not call controller#parse_equipments_items_json" do
        controller.should_not_receive(:parse_equipments_items_json)
        subject
      end
    end
    it_behaves_like "Respond to HTML and JSON"
  end

  context "#updates" do
    let(:required_params) { { :format => :json } }
    let(:append_params) {
      {
        "equipments" => {
          "0" => { "name" => "初級魔法戦士服", "stock" => "1", "renkin_count" => "0", "total_cost" => "1260" }
        },
        "items" => {
          "0" => { "name" => "あやかしそう", "stock" => "-3" },
          "1" => { "name" => "コットン草",   "stock" => "-3" }
        }
      } 
    }
    let(:req) { put :updates, params }
    context "response" do
      before { req }
      subject { response }
      it_behaves_like 'the Request that is returned "HTTP OK"'
    end
    context "@result" do
      before { req }
      subject { assigns(:result) }
      pending "そのうち書く"
    end
    context "request" do
      subject { req }
      it "should call controller#authenticate_user!" do
        controller.should_receive(:authenticate_user!)
        subject
      end
      it "should call controller#parse_equipments_items_json" do
        controller.should_receive(:parse_equipments_items_json)
        subject
      end
    end
    it_behaves_like "Respond to JSON"
  end

  context "#parse_equipments_items_json" do
    context "controller's" do

      let(:expected_results) {
        {
          equipments:  [
            { name: "初級魔法戦士服", stock: 1, renkin_count: 0, total_cost: 1260 }
          ],
          items: [
            { name: "あやかしそう", stock: -3 },
            { name: "コットン草",   stock: -3 }
          ]
        }
      }
      let(:request_params) {
        {
          "equipments" => {
            "0" => { "name" => "初級魔法戦士服", "stock" => "1", "renkin_count" => "0", "total_cost" => "1260" }
          },
          "items" => {
            "0" => { "name" => "あやかしそう", "stock" => "-3" },
            "1" => { "name" => "コットン草",   "stock" => "-3" }
          }
        }
      }

      before {
        controller.stub!(:params).and_return(request_params)
        controller.unstub!(:parse_equipments_items_json)
      }

      subject { controller.send(:parse_equipments_items_json) }

      context "instance variables" do
        before { controller.send(:parse_equipments_items_json) }
        subject { controller.instance_variables }
        it { should include :@requested_equipments_items }
      end
    
      context "@requested_equipments_items" do
        before { controller.send(:parse_equipments_items_json) }
        subject { controller.instance_variable_get(:@requested_equipments_items) }
        it { should == expected_results }
      end

    end

  end

end


