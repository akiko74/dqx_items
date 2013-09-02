require 'spec_helper'

describe "Update my item from API" do
  let(:method) { :put }
  let(:path)   { '/my/items.json' }

  context "without valid user session" do

    before(:each) do
      page.driver.send(method,path,{})
    end

    context "response" do
      subject { page.driver.response }
      context "status" do
        it { expect(subject.status).to eq 401 }
      end
    end

  end


  context "sd1 裁縫職人が初級魔法戦士服を作って登録する。コットン草は使い切る。" do
    let(:param)  {
      {
        :equipments => {
          '0' => {
            :name => '初級魔法戦士服',
            :stock => '1',
            :renkin_count => "0",
            :cost => "1260"
          }
        },
        :items => {
          '0' => {
            :name => 'あやかしそう',
            :stock => '-3'
          },
          '1' => {
            :name => 'コットン草',
            :stock => '-3'
          }
        }
      }
    }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:recipe1) {
      FactoryGirl.create(:beginners_magic_knight_ware)
    }
    let!(:inventory1) { FactoryGirl.create(:my_ayakashi_sou, user:user) }
    let!(:inventory2) { FactoryGirl.create(:my_cotton_sou, user:user) }

    context "with valid user session" do

      before(:each) do
        visit root_path
        fill_in 'user_email', :with => user.email
        fill_in 'user_password', :with => user.password
        click_button 'ログイン'
        page.driver.send(method,path,param)
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
              it { expect(subject.keys).to include "equipments" }
              it { expect(subject.keys).to include "items" }
            end
            context "items" do
              subject { JSON.parse(page.driver.response.body)["items"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my items" do
                expect(subject.length).to eq 2
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory1.item.name}\",\"stock\":7,\"cost\":290}"
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory2.item.name}\",\"stock\":0,\"cost\":0}"
              end
            end
            context "equipments" do
              subject { JSON.parse(page.driver.response.body)["equipments"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my equipments" do
                expect(subject.length).to eq 1

                expect(subject.map(&:to_json)).to include "{\"name\":\"#{recipe1.name}\",\"stock\":1,\"renkin_count\":0,\"cost\":1260}"
              end
            end
          end
        end
      end

      context "database" do
        it 'should be updated' do
          expect(Equipment.where(recipe_id:recipe1.id,user_id:user.id,cost:1260,renkin_count:0)).to_not be_empty
          expect(Inventory.where(item_id:inventory1.item.id,user_id:user.id).first.stock).to eq 7
          expect(Inventory.where(item_id:inventory2.item.id,user_id:user.id)).to be_empty
        end

      end
    end

  end

  context "sd2 ツボ職人がぬすっとの服＋１にしゅび力＋２の効果を付けて登録する。" do
    let(:param)  {
      {
        :equipments => {
          '0' => {
            :name => 'ぬすっとの服',
            :stock => '-1',
            :renkin_count => "1",
            :cost => "700"
          },
          '1' => {
            :name => 'ぬすっとの服',
            :stock => '1',
            :renkin_count => "2",
            :cost => "1050"
          },
        },
        :items => {
          '0' => {
            :name => '小さなこうら',
            :stock => '-1'
          },
          '1' => {
            :name => 'ようせいの粉',
            :stock => '-1'
          }
        }
      }
    }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:equipment1) {
      FactoryGirl.create(
        :nusutto_ware,
          cost: 700,
          renkin_count: 1,
          user: user
      )
    }
    let!(:equipment2) { FactoryGirl.create(:equipment, user:user) }
    let!(:equipment3) { FactoryGirl.create(:equipment, user:user) }
    let!(:inventory1) { FactoryGirl.create(:my_small_shell, user:user) }
    let!(:inventory2) { FactoryGirl.create(:my_fairy_powder, user:user) }

    context "with valid user session" do

      before(:each) do
        visit root_path
        fill_in 'user_email', :with => user.email
        fill_in 'user_password', :with => user.password
        click_button 'ログイン'
        page.driver.send(method,path,param)
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
              it { expect(subject.keys).to include "equipments" }
              it { expect(subject.keys).to include "items" }
            end
            context "items" do
              subject { JSON.parse(page.driver.response.body)["items"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my items" do
                expect(subject.length).to eq 2
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory1.item.name}\",\"stock\":2,\"cost\":250}"
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory2.item.name}\",\"stock\":3,\"cost\":100}"
              end
            end
            context "equipments" do
              subject { JSON.parse(page.driver.response.body)["equipments"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my equipments" do
                expect(subject.length).to eq 2

                expect(subject.map(&:to_json)).to include "{\"name\":\"#{equipment1.recipe.name}\",\"stock\":0,\"renkin_count\":1,\"cost\":700}"
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{equipment1.recipe.name}\",\"stock\":1,\"renkin_count\":2,\"cost\":1050}"
              end
            end
          end
        end
      end

      context "database" do
        it 'should be updated' do
          expect(Equipment.where(recipe_id:equipment1.recipe.id,user_id:user.id,cost:1050,renkin_count:2)).to_not be_empty
          expect(Equipment.where(recipe_id:equipment1.recipe.id,user_id:user.id,cost:700,renkin_count:1)).to be_empty
#          expect(Inventory.where(item_id:inventory1.item.id,user_id:user.id).first.stock).to eq 9
#          expect(Inventory.where(item_id:inventory2.item.id,user_id:user.id)).to be_empty
expect(Inventory.where(item_id:inventory1.item.id,user_id:user.id).first.stock).to eq 2
expect(Inventory.where(item_id:inventory2.item.id,user_id:user.id).first.stock).to eq 3

        end

      end
    end

  end

  context "sd3 武器鍛冶職人がパルチザンを作る。登録はしない。" do
    let(:param)  {
      {
        :equipments => {
        },
        :items => {
          '0' => {
            :name => 'ぎんのこうせき',
            :stock => '-6'
          },
          '1' => {
            :name => 'しなやかな枝',
            :stock => '-3'
          },
          '2' => {
            :name => 'するどいキバ',
            :stock => '-3'
          }
        }
      }
    }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:recipe1) { FactoryGirl.create(:partizan) }
    let!(:inventory1) { FactoryGirl.create(:my_silver_stone, user:user) }
    let!(:inventory2) { FactoryGirl.create(:my_supple_branch, user:user) }
    let!(:inventory3) { FactoryGirl.create(:my_sharp_fang, user:user) }

    context "with valid user session" do

      before(:each) do
        visit root_path
        fill_in 'user_email', :with => user.email
        fill_in 'user_password', :with => user.password
        click_button 'ログイン'
        page.driver.send(method,path,param)
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
              it { expect(subject.keys).to include "equipments" }
              it { expect(subject.keys).to include "items" }
            end
            context "items" do
              subject { JSON.parse(page.driver.response.body)["items"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my items" do
                expect(subject.length).to eq 3
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory1.item.name}\",\"stock\":60,\"cost\":240}"
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory2.item.name}\",\"stock\":1,\"cost\":240}"
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory3.item.name}\",\"stock\":5,\"cost\":120}"
              end
            end
            context "equipments" do
              subject { JSON.parse(page.driver.response.body)["equipments"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my equipments" do
                expect(subject.length).to eq 0
              end
            end
          end
        end
      end

      context "database" do
        it 'should be updated' do
          expect(Inventory.where(item_id:inventory1.item.id,user_id:user.id).first.stock).to eq 60
          expect(Inventory.where(item_id:inventory2.item.id,user_id:user.id).first.stock).to eq 1
          expect(Inventory.where(item_id:inventory3.item.id,user_id:user.id).first.stock).to eq 5
        end

      end
    end

  end

  context "sd4 つけもの石を３個拾って登録する。" do
    let(:param)  {
      {
        :equipments => {
        },
        :items => {
          '0' => {
            :name  => 'つけもの石',
            :stock => '3',
            :cost  => '0'
          }
        }
      }
    }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:inventory1) { FactoryGirl.create(:my_weight_stone, user:user) }

    context "with valid user session" do

      before(:each) do
        visit root_path
        fill_in 'user_email', :with => user.email
        fill_in 'user_password', :with => user.password
        click_button 'ログイン'
        page.driver.send(method,path,param)
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
              it { expect(subject.keys).to include "equipments" }
              it { expect(subject.keys).to include "items" }
            end
            context "items" do
              subject { JSON.parse(page.driver.response.body)["items"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my items" do
                expect(subject.length).to eq 1
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory1.item.name}\",\"stock\":98,\"cost\":90}"
              end
            end
            context "equipments" do
              subject { JSON.parse(page.driver.response.body)["equipments"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my equipments" do
                expect(subject.length).to eq 0
              end
            end
          end
        end
      end

      context "database" do
        it 'should be updated' do
          expect(Inventory.where(item_id:inventory1.item.id,user_id:user.id).first.stock).to eq 98
        end
      end
    end

  end

  context "sd5 あまつゆのいとを５個買って登録する。" do
    let(:param)  {
      {
        :equipments => {
        },
        :items => {
          '0' => {
            :name  => 'あまつゆのいと',
            :stock => '5',
            :cost  => '5000'
          }
        }
      }
    }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:inventory1) { FactoryGirl.create(:my_rain_and_dew_string, user:user) }

    context "with valid user session" do

      before(:each) do
        visit root_path
        fill_in 'user_email', :with => user.email
        fill_in 'user_password', :with => user.password
        click_button 'ログイン'
        page.driver.send(method,path,param)
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
              it { expect(subject.keys).to include "equipments" }
              it { expect(subject.keys).to include "items" }
            end
            context "items" do
              subject { JSON.parse(page.driver.response.body)["items"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my items" do
                expect(subject.length).to eq 1
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{inventory1.item.name}\",\"stock\":43,\"cost\":1000}"
              end
            end
            context "equipments" do
              subject { JSON.parse(page.driver.response.body)["equipments"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my equipments" do
                expect(subject.length).to eq 0
              end
            end
          end
        end
      end

      context "database" do
        it 'should be updated' do
          expect(Inventory.where(item_id:inventory1.item.id,user_id:user.id).first.stock).to eq 43
        end
      end
    end

  end

  context "sd6 どうのつるぎ（＋１）を買って登録する。" do
    let(:param)  {
      {
        :equipments => {
          '0' => {
            :name => 'どうのつるぎ',
            :stock => '1',
            :renkin_count => "1",
            :cost => "700"
          }
        },
        :items => {
        }
      }
    }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:recipe1) { FactoryGirl.create(:copper_sword) }

    context "with valid user session" do

      before(:each) do
        visit root_path
        fill_in 'user_email', :with => user.email
        fill_in 'user_password', :with => user.password
        click_button 'ログイン'
        page.driver.send(method,path,param)
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
              it { expect(subject.keys).to include "equipments" }
              it { expect(subject.keys).to include "items" }
            end
            context "items" do
              subject { JSON.parse(page.driver.response.body)["items"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my items" do
                expect(subject.length).to eq 0
              end
            end
            context "equipments" do
              subject { JSON.parse(page.driver.response.body)["equipments"] }
              it { expect(subject).to be_instance_of Array }
              it "should include my equipments" do
                expect(subject.length).to eq 1
                expect(subject.map(&:to_json)).to include "{\"name\":\"#{recipe1.name}\",\"stock\":1,\"renkin_count\":1,\"cost\":700}"
              end
            end
          end
        end
      end

      context "database" do
        it 'should be updated' do
          expect(Equipment.where(recipe_id:recipe1.id,user_id:user.id,cost:700,renkin_count:1)).to_not be_empty
        end
      end
    end

  end

end
