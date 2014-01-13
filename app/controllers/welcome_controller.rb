# encoding: utf-8


# トップページ用コントローラ
#
# @author tk.hamaguchi@gmail.com
# @since 2.0.0
#
class WelcomeController < ApplicationController

  # トップページ
  #
  # @example
  # +非ログインユーザー -> recipes#index
  # +ログイン済みユーザー -> my/items#index
  # +ログイン済み管理者 -> recipes#index
  #
  def index
    if user_signed_in?
      return redirect_to my_items_path
    else
      return redirect_to recipes_path
    end
  end
end
