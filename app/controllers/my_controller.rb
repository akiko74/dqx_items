# encoding: utf-8


# マイページ用コントローラ
#
# @author tk.hamaguchi@gmail.com
# @since 2.0.0
#
class MyController < PageController

  before_filter :authenticate_user!

end
