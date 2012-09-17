class ApplicationController < ActionController::Base
  protect_from_forgery
#  admin権限登録後に以下を有効にする。
  before_filter :authenticate_admin, :except => [ :index, :show]
end
