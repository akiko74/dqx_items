#= require dqx_items/models/dictionary_item

describe 'DqxItems.DictionaryItem', ->


  describe '@dictionary_key', ->

    it 'should be a SHA1 Hexdigest for "dictionaries"', ->
      expect(DqxItems.DictionaryItem.dictionary_key).toBe('75719660ab8198271847dc323a7374e8a4497197')


  describe '#constructor', ->

    it 'Can be created with default values', ->
      dictionary_item = new DqxItems.DictionaryItem()
      expect(dictionary_item.get('name')).toBeNull()
      expect(dictionary_item.get('kana')).toBeNull()
      expect(dictionary_item.get('type')).toBeNull()
      expect(dictionary_item.get('key')).not.toBeNull()
      expect(dictionary_item.get('key')).toBe('75719660ab8198271847dc323a7374e8a4497197' + 'da39a3ee5e6b4b0d3255bfef95601890afd80709')

    it 'Can be created with geven values', ->
      dictionary_item = new DqxItems.DictionaryItem({name:'アイテム名',kana:'あいてむめい',type:'test'})
      expect(dictionary_item.get('name')).toBe('アイテム名')
      expect(dictionary_item.get('kana')).toBe('あいてむめい')
      expect(dictionary_item.get('type')).toBe('test')
      expect(dictionary_item.get('key')).toBe('75719660ab8198271847dc323a7374e8a4497197' + '7171d9cb0cf384aa20bd424e28922175a6a3f1f5')


  describe '#save()', ->

    dictionary_item = undefined

    beforeEach ->
      spyOn(DqxItems.DataStorage, 'set').andReturn('saved object')
      dictionary_item = new DqxItems.DictionaryItem({name:'アイテム名',kana:'あいてむめい',type:'test'})

    it 'should return saved object', ->
      expect(dictionary_item.save()).toBe('saved object')

    it 'should call DqxItems.DataStorage.set with key and self', ->
      dictionary_item.save()
      expect(DqxItems.DataStorage.set).toHaveBeenCalledWith('75719660ab8198271847dc323a7374e8a44971977171d9cb0cf384aa20bd424e28922175a6a3f1f5',dictionary_item)


  describe '#destroy()', ->

    dictionary_item = undefined

    beforeEach ->
      spyOn(DqxItems.DataStorage, 'destroy').andReturn('destroyed object')
      dictionary_item = new DqxItems.DictionaryItem({name:'アイテム名',kana:'あいてむめい',type:'test'})

    it 'should return key of destroyed item', ->
      expect(dictionary_item.destroy()).toBe('75719660ab8198271847dc323a7374e8a44971977171d9cb0cf384aa20bd424e28922175a6a3f1f5')

    it 'should call DqxItems.DataStorage.destroy with key and self', ->
      dictionary_item.destroy()
      expect(DqxItems.DataStorage.destroy).toHaveBeenCalledWith('75719660ab8198271847dc323a7374e8a44971977171d9cb0cf384aa20bd424e28922175a6a3f1f5')


  describe '.findByKey()', ->

    beforeEach ->
      spyOn(DqxItems.DataStorage, 'get').andReturn({name:'アイテム名',kana:'あいてむめい',type:'test'})

    it 'should call DqxItems.DataStorage.get with key', ->
      DqxItems.DictionaryItem.findByKey('75719660ab8198271847dc323a7374e8a44971977171d9cb0cf384aa20bd424e28922175a6a3f1f5')
      expect(DqxItems.DataStorage.get).toHaveBeenCalledWith('75719660ab8198271847dc323a7374e8a44971977171d9cb0cf384aa20bd424e28922175a6a3f1f5')

    it 'should return with DqxItems.DictionaryItem', ->
      finded = DqxItems.DictionaryItem.findByKey('75719660ab8198271847dc323a7374e8a44971977171d9cb0cf384aa20bd424e28922175a6a3f1f5')
      expect(typeof finded).toBe('object')
      expect(finded.constructor.name).toBe("DictionaryItem")
      expect(finded.get('name')).toBe('アイテム名')
      expect(finded.get('kana')).toBe('あいてむめい')
      expect(finded.get('type')).toBe('test')
      expect(finded.get('key')).toBe('75719660ab8198271847dc323a7374e8a4497197' + '7171d9cb0cf384aa20bd424e28922175a6a3f1f5')


  describe '.findByKey()', ->

    beforeEach ->
      spyOn(DqxItems.DictionaryItem, 'findByKey').andReturn('finded_item')

    it 'should return with finded item', ->
      expect(DqxItems.DictionaryItem.findByName('アイテム名')).toBe('finded_item')

    it 'should call DqxItems.DictionaryItem.findByKey with generated key', ->
      DqxItems.DictionaryItem.findByName('アイテム名')
      expect(DqxItems.DictionaryItem.findByKey).toHaveBeenCalledWith('75719660ab8198271847dc323a7374e8a44971977171d9cb0cf384aa20bd424e28922175a6a3f1f5')

