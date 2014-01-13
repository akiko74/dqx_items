require 'spec_helper'

describe PageController do

  context "#authenticate_admin" do
    subject { controller.send(:authenticate_admin) }
    context "with admin" do
      before { controller.stub!(:admin_signed_in?).and_return(true) }
      it { expect{subject}.to_not raise_error }
    end
    context "without admin" do
      before { controller.stub!(:admin_signed_in?).and_return(false) }
      it { expect{subject}.to raise_error ActionController::RoutingError }
    end
  end

end
