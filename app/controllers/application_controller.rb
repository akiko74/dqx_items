class ApplicationController < ActionController::Base
  protect_from_forgery
#  admin権限登録後に以下を有効にする。
#  before_filter :authenticate_admin, :except => [ :index, :show]
  before_filter :authenticate_admin, :except => [ :index, :show]

  def authenticate_admin
    unless admin_signed_in?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
