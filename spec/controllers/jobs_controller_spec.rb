# encoding: utf-8


require 'spec_helper'


describe JobsController do

  context "#index" do

    subject { get :index }
    let!(:jobs) {
      (5..10).to_a.sample.times.inject([]) do |ary,i|
        ary << FactoryGirl.create(:job)
        ary
      end
    }
    #let(:admin) { FactoryGirl.create(:admin) }

    context 'with registed admin' do
      #before { sign_in admin }
      it_should_behave_like 'the Request that is returned "Job list Page"'
      context '@jobs' do
        subject {
          get :index
          assigns(:jobs)
        }
        it "should assigns" do
          should == jobs
        end
      end
    end

    context 'with nobody' do
      it_should_behave_like 'the Request that is returned "Job list Page"'
      context '@jobs' do
        subject {
          get :index
          assigns(:jobs)
        }
        it "should assigns" do
          should == jobs
        end
      end
    end
  end


  context "#show" do

    subject { get :show, :id => job.id }
    let(:job) { FactoryGirl.create(:job) }

    context 'with registed admin' do
      #before { sign_in admin }
      it_should_behave_like 'the Request that is returned "Job Page"'
      context '@job' do
        subject {
          get :show, :id => job.id
          assigns(:job)
        }
        it "should assigns" do
          should == job
        end
      end
    end

    context 'with nobody' do
      it_should_behave_like 'the Request that is returned "Job Page"'
      context '@job' do
        subject {
          get :show, :id => job.id
          assigns(:job)
        }
        it "should assigns" do
          should == job
        end
      end
    end

  end









  # This should return the minimal set of attributes required to create a valid
  # Job. As you add validations to Job, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JobsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET new" do
    it "assigns a new job as @job" do
      get :new, {}, valid_session
      assigns(:job).should be_a_new(Job)
    end
  end

  describe "GET edit" do
    it "assigns the requested job as @job" do
      job = Job.create! valid_attributes
      get :edit, {:id => job.to_param}, valid_session
      assigns(:job).should eq(job)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Job" do
        expect {
          post :create, {:job => valid_attributes}, valid_session
        }.to change(Job, :count).by(1)
      end

      it "assigns a newly created job as @job" do
        post :create, {:job => valid_attributes}, valid_session
        assigns(:job).should be_a(Job)
        assigns(:job).should be_persisted
      end

      it "redirects to the created job" do
        post :create, {:job => valid_attributes}, valid_session
        response.should redirect_to(Job.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job as @job" do
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        post :create, {:job => {}}, valid_session
        assigns(:job).should be_a_new(Job)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        post :create, {:job => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested job" do
        job = Job.create! valid_attributes
        # Assuming there are no other jobs in the database, this
        # specifies that the Job created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Job.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => job.to_param, :job => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested job as @job" do
        job = Job.create! valid_attributes
        put :update, {:id => job.to_param, :job => valid_attributes}, valid_session
        assigns(:job).should eq(job)
      end

      it "redirects to the job" do
        job = Job.create! valid_attributes
        put :update, {:id => job.to_param, :job => valid_attributes}, valid_session
        response.should redirect_to(job)
      end
    end

    describe "with invalid params" do
      it "assigns the job as @job" do
        job = Job.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        put :update, {:id => job.to_param, :job => {}}, valid_session
        assigns(:job).should eq(job)
      end

      it "re-renders the 'edit' template" do
        job = Job.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Job.any_instance.stub(:save).and_return(false)
        put :update, {:id => job.to_param, :job => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested job" do
      job = Job.create! valid_attributes
      expect {
        delete :destroy, {:id => job.to_param}, valid_session
      }.to change(Job, :count).by(-1)
    end

    it "redirects to the jobs list" do
      job = Job.create! valid_attributes
      delete :destroy, {:id => job.to_param}, valid_session
      response.should redirect_to(jobs_url)
    end
  end

end
