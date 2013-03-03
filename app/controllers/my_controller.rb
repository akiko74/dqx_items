# encoding: utf-8


# マイページ用コントローラ
#
# @author tk.hamaguchi@gmail.com
# @since 2.0.0
#
class MyController < PageController

  skip_before_filter :authenticate_admin
  before_filter :authenticate_user!

end
