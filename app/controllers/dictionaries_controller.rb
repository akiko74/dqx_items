# encoding: utf-8


# 辞書用コントローラ
#
# @since 2.0.0
#
class DictionariesController < ApplicationController

  def index
    @result = Item.all.map(&:to_dictionary_hash) + Recipe.all.map(&:to_dictionary_hash)
    respond_to do |format|
      format.json { render json: @result }
    end
  end

end
