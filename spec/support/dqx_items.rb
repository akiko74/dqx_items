# encoding: utf-8


shared_context 'http-request' do
  let(:required_params) { {} }
  let(:append_params) { {} }
  let(:params) { required_params.merge(append_params) }
end

shared_examples_for 'Respond to HTML and JSON' do
  context "without :format" do
    before { req }
    subject { response }
    its(:content_type) { should == "text/html" }
  end
  context 'with :format => "json"' do
    before { req }
    subject { response }
    let(:append_params) { { :format => "json" } }
    its(:content_type) { should == "application/json" }
  end
  context 'with :format => "html"' do
    before { req }
    subject { response }
    let(:append_params) { { :format => "html" } }
    its(:content_type) { should == "text/html" }
  end
end






share_examples_for 'the Request that is returned "HTTP OK"' do
  it { should be_success }
  its(:status) { should equal 200 }
end

share_examples_for 'the Request that is returned "HTTP Found"' do
  it { should be_redirect }
  its(:status) { should equal 302 }
end

share_examples_for 'the Request that is redirected to "Home Page"' do
  it_should_behave_like 'the Request that is returned "HTTP Found"'
  it { should redirect_to root_path }
end

share_examples_for 'the Request that is redirected to "Recipe Page"' do
  it_should_behave_like 'the Request that is returned "HTTP Found"'
  it { subject ; should redirect_to recipe_path(:id => assigns(:recipe).id) }
end

share_examples_for 'the Request that is redirected to "Recipe list Page"' do
  it_should_behave_like 'the Request that is returned "HTTP Found"'
  it { subject ; should redirect_to recipes_path }
end

share_examples_for 'the Request that is returned "Item list Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'items/index' }
end

share_examples_for 'the Request that is returned "Recipe list Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'recipes/index' }
end

share_examples_for 'the Request that is returned "Job list Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'jobs/index' }
end

share_examples_for 'the Request that is returned "Item regist Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'items/new' }
end

share_examples_for 'the Request that is returned "Recipe regist Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'recipes/new' }
end

share_examples_for 'the Request that is returned "Job regist Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'jobs/new' }
end

share_examples_for 'the Request that is returned "Item edit Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'items/edit' }
end

share_examples_for 'the Request that is returned "Recipe edit Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'recipes/edit' }
end

share_examples_for 'the Request that is returned "Job edit Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'jobs/edit' }
end

share_examples_for 'the Request that is returned "Item Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'items/show' }
end

share_examples_for 'the Request that is returned "Recipe Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'recipes/show' }
end

share_examples_for 'the Request that is returned "Job Page"' do
  it_should_behave_like 'the Request that is returned "HTTP OK"'
  it { should render_template "layouts/application" }
  it { should render_template 'jobs/show' }
end


