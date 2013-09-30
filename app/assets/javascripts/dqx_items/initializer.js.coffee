window.DqxItems.Initializer = class Initializer

  options: undefined

  constructor: (options={}) ->
    @options = options
    DqxItems.Initializer.adjustWindow(jQuery('body').css('width'))
    dictionaryItemList = new DqxItems.DictionaryItemList()
    dictionaryItemList.fetchItemsFromStorage()
    dictionaryItemList.fetch({async:false})
    if @isSignedIn()
      console.log 'User signed in.'
      #console.log (new DqxItems.MyItemList()).fetch()

  isSignedIn: (judgementId = "#login_button") ->
    (jQuery(judgementId).length == 0 )

  @adjustWindow: (width, brandElm=jQuery('.brand')) ->
    if parseInt(width) < 480
      brandElm.html('DQ10 逆引きレシピβ')
    else
      brandElm.html('ドラゴンクエスト10 逆引きレシピβ')
