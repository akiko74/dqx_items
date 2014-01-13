require 'spec_helper'

describe "Fetch my items from API" do
  let(:method) { :get }
  let(:path)   { '/my/items.json' }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:equipment1) { FactoryGirl.create(:equipment, user:user) }
  let!(:equipment2) { FactoryGirl.create(:equipment, user:user) }
  let!(:equipment3) { FactoryGirl.create(:equipment, user:user) }
  let!(:inventory1) { FactoryGirl.create(:inventory, user:user) }
  let!(:inventory2) { FactoryGirl.create(:inventory, user:user) }

  context "without valid user session" do

    before(:each) do
      page.driver.send(method,path)
    end

    context "response" do
      subject { page.driver.response }
      context "status" do
        it { expect(subject.status).to eq 401 }
      end
    end

  end

  context "with valid user session" do

    before(:each) do
      visit root_path
      fill_in 'user_email', :with => user.email
      fill_in 'user_password', :with => user.password
      click_button 'ログイン'
      page.driver.send(method,path)
    end

    context "response" do
      subject { page.driver.response }
      context "status" do
        it { expect(subject.status).to eq 200 }
      end
      context "body" do
        it { expect(subject.body).to_not be_blank }
        it "should be valid json" do
          expect(JSON.parse(subject.body)).to be_true
        end
        context "parsed" do
          subject { JSON.parse(page.driver.response.body).with_indifferent_access }
          context "keys" do
            it { expect(subject.keys).to include "uid" }
            it { expect(subject.keys).to include "equipments" }
            it { expect(subject.keys).to include "items" }
          end
          context "uid" do
            it 'should eq Digest::SHA1.hexdigest("user-#{user.id}")' do
              expect(subject["uid"]).to eq Digest::SHA1.hexdigest("user-#{user.id}")
            end
          end
          context "items" do
            subject { JSON.parse(page.driver.response.body)["items"] }
            it { expect(subject).to be_instance_of Array }
            it "should include my items" do
              expect(subject.length).to eq 2
              expect(subject.map(&:to_json)).to include item_to_json(inventory1)
              expect(subject.map(&:to_json)).to include item_to_json(inventory2)
            end
          end
          context "equipments" do
            subject { JSON.parse(page.driver.response.body)["equipments"] }
            it { expect(subject).to be_instance_of Array }
            it "should include my equipments" do
              expect(subject.length).to eq 3

              expect(subject.map(&:to_json)).to include equipment_to_json(equipment1)
              expect(subject.map(&:to_json)).to include equipment_to_json(equipment2)
              expect(subject.map(&:to_json)).to include equipment_to_json(equipment3)
            end
          end
        end
      end
    end

  end

end

def equipment_to_json(equipment3)
  "{\"recipe_name\":\"#{equipment3.recipe.name}\",\"recipe_kana\":\"#{equipment3.recipe.kana}\",\"cost\":#{equipment3.cost},\"renkin_count\":#{equipment3.renkin_count}}"
end

def item_to_json(inventory)
  "{\"name\":\"#{inventory.item.name}\",\"kana\":\"#{inventory.item.kana}\",\"stock\":#{inventory.stock},\"cost\":#{inventory.total_cost / inventory.stock}}"
end
