#= require dqx_items/models/my_equipment

describe 'DqxItems.MyEquipment', ->


  describe '#constructor', ->

    it 'should be created with default values', ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_equipment = new DqxItems.MyEquipment()
      expect(my_equipment.get('name')).toBeNull()
      expect(my_equipment.get('renkin_count')).not.toBeNull()
      expect(my_equipment.get('renkin_count')).toBe(0)
      expect(my_equipment.get('cost')).not.toBeNull()
      expect(my_equipment.get('cost')).toBe(0)
      expect(my_equipment.get('kana')).toBeNull()
      expect(my_equipment.get('key')).not.toBeNull()
      expect(my_equipment.get('key')).toBe('mmmykkkey' + 'ffe5c2042056b006158398c1aa99a99ad5865ed6')
      expect(my_equipment.get('usage_count')).not.toBeNull()
      expect(my_equipment.get('usage_count')).toBe(1)

    it "should be created with geven values that's full condition", ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([{name:'アイテム名',kana:'あいてむめい',type:'test'}]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_equipment = new DqxItems.MyEquipment({name:'アイテム名', cost:100, renkin_count:2, usage_count:10})
      expect(my_equipment.get('name')).toBe('アイテム名')
      expect(my_equipment.get('renkin_count')).toBe(2)
      expect(my_equipment.get('cost')).toBe(100)
      expect(my_equipment.get('kana')).toBe('あいてむめい')
      expect(my_equipment.get('key')).toBe('mmmykkkey' + '45418e795b9797e2735f3137b064f99090353ad1')
      expect(my_equipment.get('usage_count')).toBe(10)

    it "should be created with geven values that's not registed item", ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_equipment = new DqxItems.MyEquipment({name:'アイテム名', cost:10, renkin_count:1, usage_count:10})
      expect(my_equipment.get('name')).toBe('アイテム名')
      expect(my_equipment.get('renkin_count')).toBe(1)
      expect(my_equipment.get('cost')).toBe(10)
      expect(my_equipment.get('kana')).toBeNull()
      expect(my_equipment.get('key')).toBe('mmmykkkey' + 'd4a71ba4fcfdf6f870956a8bef01c7c211eafb79')
      expect(my_equipment.get('usage_count')).toBe(10)

    it "should be created with geven values that's had recipe_name", ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([{name:'アイテム名',kana:'あいてむめい',type:'test'}]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_equipment = new DqxItems.MyEquipment({recipe_name:'アイテム名', cost:100, renkin_count:2, usage_count:10})
      expect(my_equipment.get('name')).toBe('アイテム名')
      expect(my_equipment.get('renkin_count')).toBe(2)
      expect(my_equipment.get('cost')).toBe(100)
      expect(my_equipment.get('kana')).toBe('あいてむめい')
      expect(my_equipment.get('key')).toBe('mmmykkkey' + '45418e795b9797e2735f3137b064f99090353ad1')
      expect(my_equipment.get('usage_count')).toBe(10)


  describe 'toParam()', ->

    it "should be {name:'アイテム名',renkin_count:2,cost:100,stock:0}", ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([{name:'アイテム名',kana:'あいてむめい',type:'test'}]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_equipment = new DqxItems.MyEquipment({recipe_name:'アイテム名', cost:100, renkin_count:2, usage_count:10})
      expect(typeof my_equipment.toParam()).toBe('object')
      expect(my_equipment.toParam().name).toBe('アイテム名')
      expect(my_equipment.toParam().renkin_count).toBe(2)
      expect(my_equipment.toParam().cost).toBe(100)
      expect(my_equipment.toParam().stock).toBe(0)



  describe '#destroy()', ->

    my_equipment = undefined
    toParamed   = undefined

    beforeEach ->
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([{name:'アイテム名',kana:'あいてむめい',type:'test'}]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_equipment = new DqxItems.MyEquipment({recipe_name:'アイテム名', cost:100, renkin_count:2, usage_count:10})
      toParamed = {name:'アイテム名',renkin_count:2,cost:100,stock:0}
      spyOn(my_equipment,'toParam').andReturn(toParamed)
      spyOn(DqxItems.MyItem,'update_my_items').andReturn('DqxItems.MyItem.update_my_items result')

    it 'should return DqxItems.MyItem.update_my_items results', ->
      expect(my_equipment.destroy()).toBe('DqxItems.MyItem.update_my_items result')

    it 'should call DqxItems.DataStorage.destroy with key and self', ->
      my_equipment.destroy()
      expect(DqxItems.MyItem.update_my_items).toHaveBeenCalledWith([],[toParamed])


  describe '#save()', ->

    my_equipment = undefined

    beforeEach ->
      spyOn(DqxItems.DataStorage, 'set').andReturn('saved object')
      spyOn(DqxItems,'DictionaryItemList').andReturn(new Backbone.Collection([{name:'アイテム名',kana:'あいてむめい',type:'test'}]))
      spyOn(DqxItems.MyItem,'my_key').andReturn('mmmykkkey')
      my_equipment = new DqxItems.MyEquipment({recipe_name:'アイテム名', cost:100, renkin_count:2, usage_count:10})

    it 'should return saved object', ->
      expect(my_equipment.save()).toBe('saved object')

    it 'should call DqxItems.DataStorage.set with key and self', ->
      my_equipment.save()
      expect(DqxItems.DataStorage.set).toHaveBeenCalledWith('mmmykkkey45418e795b9797e2735f3137b064f99090353ad1',my_equipment)


