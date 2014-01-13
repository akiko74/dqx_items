#= require dqx_items/models/my_item_inventory

describe 'DqxItems.MyItemInventory', ->


  describe '#constructor', ->

    it 'should be created with default values', ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_item_inventory = new DqxItems.MyItemInventory()
      expect(my_item_inventory.get('name')).toBeNull()
      expect(my_item_inventory.get('stock')).not.toBeNull()
      expect(my_item_inventory.get('stock')).toBe(0)
      expect(my_item_inventory.get('cost')).not.toBeNull()
      expect(my_item_inventory.get('cost')).toBe(0)
      expect(my_item_inventory.get('kana')).toBeNull()
      expect(my_item_inventory.get('key')).not.toBeNull()
      expect(my_item_inventory.get('key')).toBe('mmmykkkey' + 'da39a3ee5e6b4b0d3255bfef95601890afd80709')

    it "should be created with geven values that's full condition", ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([{name:'アイテム名',kana:'あいてむめい',type:'test'}]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_item_inventory = new DqxItems.MyItemInventory({name:'アイテム名', stock:50, cost:100})
      expect(my_item_inventory.get('name')).toBe('アイテム名')
      expect(my_item_inventory.get('stock')).toBe(50)
      expect(my_item_inventory.get('cost')).toBe(100)
      expect(my_item_inventory.get('kana')).toBe('あいてむめい')
      expect(my_item_inventory.get('key')).toBe('mmmykkkey' + '7171d9cb0cf384aa20bd424e28922175a6a3f1f5')

    it "should be created with geven values that's not registed item", ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_item_inventory = new DqxItems.MyItemInventory({name:'アイテム名', stock:1, cost:10})
      expect(my_item_inventory.get('name')).toBe('アイテム名')
      expect(my_item_inventory.get('stock')).toBe(1)
      expect(my_item_inventory.get('cost')).toBe(10)
      expect(my_item_inventory.get('kana')).toBeNull()
      expect(my_item_inventory.get('key')).toBe('mmmykkkey' + '7171d9cb0cf384aa20bd424e28922175a6a3f1f5')

    it "should be created with geven values that's had total_cost", ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([{name:'アイテム名',kana:'あいてむめい',type:'test'}]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_item_inventory = new DqxItems.MyItemInventory({name:'アイテム名', total_cost:10000, stock:10})
      expect(my_item_inventory.get('name')).toBe('アイテム名')
      expect(my_item_inventory.get('stock')).toBe(10)
      expect(my_item_inventory.get('cost')).toBe(1000)
      expect(my_item_inventory.get('kana')).toBe('あいてむめい')
      expect(my_item_inventory.get('key')).toBe('mmmykkkey' + '7171d9cb0cf384aa20bd424e28922175a6a3f1f5')


  describe '#save()', ->

    my_item_inventory = undefined

    beforeEach ->
      spyOn(DqxItems.DataStorage, 'set').andReturn('saved object')
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([{name:'アイテム名',kana:'あいてむめい',type:'test'}]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_item_inventory = new DqxItems.MyItemInventory({name:'アイテム名', stock:3, cost:300})

    it 'should return saved object', ->
      expect(my_item_inventory.save()).toBe('saved object')

    it 'should call DqxItems.DataStorage.set with key and self', ->
      my_item_inventory.save()
      expect(DqxItems.DataStorage.set).toHaveBeenCalledWith('mmmykkkey7171d9cb0cf384aa20bd424e28922175a6a3f1f5',my_item_inventory)


