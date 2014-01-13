# encoding: utf-8



前提 /^下記のユーザーが登録されている:$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create :user, hash
  end
end

もし /^"(.*?)"を開く$/ do |page_name|
  visit path_to page_name
end

もし /^ログインフォームに下記の情報を入力し、ログインする:$/ do |table|
  table.hashes.each do |hash|
    within("form#new_user") do
      fill_in 'user[email]',    :with => hash['Email']
      fill_in 'user[password]', :with => hash['Password']
    end
    click_button "ログイン"
  end
end

ならば /^ステータスコード"(.*?)"が返っている$/ do |status|
  page.status_code.should == status.to_i
end

ならば /^"(.*?)"にいる$/ do |page_name|
  page.current_path.should == path_to(page_name)
end

ならば /^タイトルが"(.*?)"となっている$/ do |title|
  find(:xpath, '//title').text.should == title
end
