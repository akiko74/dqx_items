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


