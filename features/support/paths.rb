# encoding: utf-8


module NavigationHelpers

  def path_to(page_name)
    case page_name
    when /ホームページ/
      root_path
    when /レシピ検索ページ/
      recipes_path
    when /ユーザーログインページ/
      new_user_session_path
    when /マイページ/
      my_items_path
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end

end

World(NavigationHelpers)
