# encoding: utf-8


require "spec_helper"


describe "routing to /my/items" do
  subject { { method => path } }

  context "GET" do
    let(:method) { :get }

    context "/my/items" do
      let(:path) { "/my/items" }
      include_examples 'the Routing that is routable with:', {
        :controller => 'my/items',
        :action     => 'index' 
      }
    end

    context "/my/items.html" do
      let(:path) { "/my/items.html" }
      include_examples 'the Routing that is routable with:', {
        :controller => 'my/items',
        :action     => 'index', 
        :format     => 'html'
      }
    end

    context "/my/items.json" do
      let(:path) { "/my/items.json" }
      include_examples 'the Routing that is routable with:', {
        :controller => 'my/items',
        :action     => 'index', 
        :format     => 'json'
      }
    end

    context "/my/items/1" do
      let(:path) { "/my/items/1" }
      it { should_not be_routable }
    end

    context "/my/items/new" do
      let(:path) { "/my/items/new" }
      it { should_not be_routable }
    end

    context "/my/items/1/edit" do
      let(:path) { "/my/items/1/edit" }
      it { should_not be_routable }
    end

  end

  context "POST" do
    let(:method) { :post }

    context "/my/items" do
      let(:path) { "/my/items" }
      it { should_not be_routable }
    end

  end

  context "PUT" do
    let(:method) { :put }

    context "/my/items/1" do
      let(:path) { "/my/items/1" }
      it { should_not be_routable }
    end

    context "/my/items" do
      let(:path) { "/my/items" }
      include_examples 'the Routing that is routable with:', {
        :controller => 'my/items',
        :action     => 'updates' 
      }
    end

    context "/my/items.html" do
      let(:path) { "/my/items.html" }
      include_examples 'the Routing that is routable with:', {
        :controller => 'my/items',
        :action     => 'updates', 
        :format     => 'html'
      }
    end

    context "/my/items.json" do
      let(:path) { "/my/items.json" }
      include_examples 'the Routing that is routable with:', {
        :controller => 'my/items',
        :action     => 'updates', 
        :format     => 'json'
      }
    end

  end

  context "DELETE" do
    let(:method) { :delete }

    context "/my/items/1" do
      let(:path) { "/my/items/1" }
      it { should_not be_routable }
    end

  end

end

