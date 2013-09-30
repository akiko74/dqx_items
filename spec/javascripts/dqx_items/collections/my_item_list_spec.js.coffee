#= require dqx_items/collections/my_item_list

describe 'DqxItems.MyItemList', ->

  xdescribe '#constructor?', ->

    beforeEach ->
      localStorage.clear()
      @server = sinon.fakeServer.create()
      @server.respondWith(
        "GET",
        "/my/items.json",
        [
          200,
          { "Content-Type":"application/json", "Etag":"3e732667a08542367a73639a6bf07ec9"},
          '{"uid":"9dfffe450852c20c8876f6e5a37da6e469bf2c9c","equipments":[{"recipe_name":"はやぶさの剣","recipe_kana":"はやぶさのけん","cost":1000,"renkin_count":0}],"items":[{"name":"どうのこうせき","kana":"どうのこうせき","stock":25,"cost":14},{"name":"ぎんのこうせき","kana":"ぎんのこうせき","stock":2890,"cost":5},{"name":"あまつゆのいと","kana":"あまつゆのいと","stock":4,"cost":32},{"name":"てっこうせき","kana":"てっこうせき","stock":20,"cost":52},{"name":"プラチナこうせき","kana":"ぷらちなこうせき","stock":1,"cost":100}]}'
        ]
      )
      spyOn(DqxItems,'DictionaryItemList').andReturn(
        new Backbone.Collection([
          {name:'はやぶさの剣',kana:'はやぶさのけん',type:'recipe'},
          {name:'どうのこうせき',kana:'どうのこうせき',type:'item'},
          {name:'ぎんのこうせき',kana:'ぎんのこうせき',type:'item'},
          {name:'あまつゆのいと',kana:'あまつゆのいと',type:'item'},
          {name:'てっこうせき',kana:'てっこうせき',type:'item'},
          {name:'プラチナこうせき',kana:'ぷらちなこうせき',type:'item'}
        ])
      )

      console.log this.server
      console.log 'faked'


    afterEach ->
      @server.restore()

    it 'tmp', ->
      console.log '-----'
      console.log myItemList = new DqxItems.MyItemList()
      console.log '-----'
      @server.respond()
      expect(myItemList).toBe([])


  describe '#constructor', ->

    myItemList          = undefined
    myEquipmentList     = undefined
    myItemInventoryList = undefined

    beforeEach ->
      myEquipmentList     = new Backbone.Collection()
      myItemInventoryList = new Backbone.Collection()
      spyOn(DqxItems, 'MyEquipmentList').andReturn(myEquipmentList)
      spyOn(DqxItems, 'MyItemInventoryList').andReturn(myItemInventoryList)


    describe 'with registed my key', ->

      beforeEach ->
        spyOn(DqxItems.DataStorage,'raw_get').andReturn('my key')
        myItemList = new DqxItems.MyItemList()


      describe '@items', ->

        it 'should set DqxItems.MyItemInventoryList()', ->
          expect(myItemList.items).toBe(myItemInventoryList)


      describe '@equipments', ->

        it 'should set DqxItems.MyEquipmentList()', ->
          expect(myItemList.equipments).toBe(myEquipmentList)


      describe '@myKey', ->

        it 'should set DqxItems.DataStorage.raw_get("my_key")', ->
          expect(myItemList.myKey).toBe('my key')


    describe 'without registed my key', ->

      beforeEach ->
        localStorage.clear()
        myItemList = new DqxItems.MyItemList()


      describe '@items', ->

        it 'should set DqxItems.MyItemInventoryList()', ->
          expect(myItemList.items).toBe(myItemInventoryList)


      describe '@equipments', ->

        it 'should set DqxItems.MyEquipmentList()', ->
          expect(myItemList.equipments).toBe(myEquipmentList)


      describe '@myKey', ->

        it 'should not set', ->
          expect(myItemList.myKey).not.toBeDefined()


  describe '#fetch()', ->

    myItemList          = undefined
    myEquipmentList     = undefined
    myItemInventoryList = undefined

    beforeEach ->
      myEquipmentList     = new Backbone.Collection()
      myItemInventoryList = new Backbone.Collection()
      spyOn(DqxItems, 'MyEquipmentList').andReturn(myEquipmentList)
      spyOn(DqxItems, 'MyItemInventoryList').andReturn(myItemInventoryList)


    describe 'with registed my key', ->

      calledResult = undefined

      beforeEach ->
        myItemList = new DqxItems.MyItemList()
        calledResult = new Backbone.Collection()
        spyOn(Backbone.Collection.prototype.fetch,'call').andReturn(calledResult)

      it 'should call Backbone.Collection.prototype.fetch.call with "@,{beforeSend:@beforeSend,parse:@parse}"', ->
        myItemList.fetch()
        expect(Backbone.Collection.prototype.fetch.call).toHaveBeenCalledWith(myItemList,{beforeSend:myItemList.beforeSend, parse:myItemList.parse})

      it 'should be super class returned', ->
        expect(myItemList.fetch()).toBe(calledResult)


  describe '#beforeSend()', ->

    myItemList          = undefined
    myEquipmentList     = undefined
    myItemInventoryList = undefined
    xhr = undefined
    stub = undefined

    beforeEach ->
      myEquipmentList     = new Backbone.Collection()
      myItemInventoryList = new Backbone.Collection()
      spyOn(DqxItems, 'MyEquipmentList').andReturn(myEquipmentList)
      spyOn(DqxItems, 'MyItemInventoryList').andReturn(myItemInventoryList)
      myItemList = new DqxItems.MyItemList()

#     xhr = sinon.spy()

      #spy = sinon.spy(xhr, 'setRequestHeader')
      #spy.withArgs('if-none-match','etag from storage')

      xhr = new Object()
      stub = sinon.stub(xhr,'setRequestHeader')
      stub.withArgs('if-none-match','etag from storage').and_return(true)

    afterEach ->
      stub.restore()

    describe 'with registed etag', ->

      beforeEach ->
        spyOn(DqxItems.DataStorage,'raw_get').andReturn('etag from storage')

      it 'aaa', ->
        myItemList.beforeSend(xhr)
        #expect(@xhr.setRequestHeader).toHaveBeenCalledWith('if-none-match','etag from storage')

