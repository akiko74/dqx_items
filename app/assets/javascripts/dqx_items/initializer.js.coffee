window.DqxItems.Initializer = class Initializer

  options: undefined

  constructor: (options={}) ->
    @options = options
    DqxItems.Initializer.adjustWindow(jQuery('body').css('width'))
    DqxItems.DictionaryItemList.build()

    if @isSignedIn()
      console.log 'User signed in.'
      myItemList = new DqxItems.MyItemList()
      myItemList.fetch({async:false})
      console.log myItemList

  isSignedIn: (judgementId = "#login_button") ->
    (jQuery(judgementId).length == 0 )

  @adjustWindow: (width, brandElm=jQuery('.navbar-brand')) ->
    if parseInt(width) < 480
      brandElm.html('DQ10 逆引きレシピβ')
    else if parseInt(width) < 520
      brandElm.html('ドラクエ10 逆引きレシピβ')
    else
      brandElm.html('ドラゴンクエスト10 逆引きレシピβ')

  @appendAffiliate: () ->
    $('.amazon_affiliate').html(
      '''
        <div class="amazon_affiliate180">
          <script type="text/javascript"><!--
            amazon_ad_tag = "3qrfactory01-22"; amazon_ad_width = "180"; amazon_ad_height = "150"; amazon_ad_link_target = "new"; amazon_ad_price = "retail"; //--></script>
          <script type="text/javascript" src="http://www.assoc-amazon.jp/s/ads.js"></script>
        </div>
        <div class="amazon_affiliate300">
          <script type="text/javascript"><!--
            amazon_ad_tag = "3qrfactory01-22"; amazon_ad_width = "300"; amazon_ad_height = "250"; amazon_ad_link_target = "new"; amazon_ad_price = "retail";//--></script>
          <script type="text/javascript" src="http://www.assoc-amazon.jp/s/ads.js"></script>
        </div>
      '''
    )
