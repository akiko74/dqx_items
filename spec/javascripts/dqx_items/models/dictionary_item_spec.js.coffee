#= require dqx_items/models/dictionary_item

describe 'DqxItems.DictionaryItem', ->


  describe '@dictionary_key', ->

    it 'should be a generated code', ->
      expect(DqxItems.DictionaryItem.dictionary_key).toBe('75719660ab8198271847dc323a7374e8a4497197')


  describe '#constructor', ->

    beforeEach ->
      DqxItems.DictionaryItem.dictionary_key = 'dictionary_key'
      spyOn(DqxItems.CodeGenerator,'generate').andReturn('generated_code')

    afterEach ->
      DqxItems.DictionaryItem.dictionary_key = DqxItems.CodeGenerator.generate("dictionaries")


    describe 'with no args', ->

      dictionary_item = undefined

      beforeEach ->
        dictionary_item = new DqxItems.DictionaryItem()

      it 'should be created', ->
        expect(dictionary_item.get('name')).toBeNull()
        expect(dictionary_item.get('kana')).toBeNull()
        expect(dictionary_item.get('type')).toBeNull()
        expect(dictionary_item.get('key')).not.toBeNull()
        expect(dictionary_item.get('key')).toBe('dictionary_key'+'generated_code')

      it 'should call DqxItems.CodeGenerator.generate() with "".', ->
        expect(DqxItems.CodeGenerator.generate).toHaveBeenCalledWith(null)


    describe 'with valid args', ->

      dictionary_item = undefined

      beforeEach ->
        dictionary_item = new DqxItems.DictionaryItem(
          {name:'アイテム名',kana:'あいてむめい',type:'test'}
        )

      it 'should be created', ->
        expect(dictionary_item.get('name')).toBe('アイテム名')
        expect(dictionary_item.get('kana')).toBe('あいてむめい')
        expect(dictionary_item.get('type')).toBe('test')
        expect(dictionary_item.get('key')).toBe('dictionary_key'+'generated_code')

      it 'should call DqxItems.CodeGenerator.generate() with "アイテム名".', ->
        expect(DqxItems.CodeGenerator.generate).toHaveBeenCalledWith('アイテム名')


    describe 'with full args', ->

      dictionary_item = undefined

      beforeEach ->
        dictionary_item = new DqxItems.DictionaryItem(
          {name:'アイテム名',kana:'あいてむめい',type:'test', key:'params_key'}
        )

      it 'should be created', ->
        expect(dictionary_item.get('name')).toBe('アイテム名')
        expect(dictionary_item.get('kana')).toBe('あいてむめい')
        expect(dictionary_item.get('type')).toBe('test')
        expect(dictionary_item.get('key')).toBe('params_key')

      it 'should call DqxItems.CodeGenerator.generate() with "アイテム名".', ->
        expect(DqxItems.CodeGenerator.generate).not.toHaveBeenCalledWith('アイテム名')


  describe '#save()', ->

    dictionary_item = undefined

    beforeEach ->
      spyOn(DqxItems.DataStorage, 'set').andReturn('saved object')
      dictionary_item = new DqxItems.DictionaryItem(
        {name:'アイテム名',kana:'あいてむめい',type:'test',key:'paramedKey'}
      )

    it 'should return saved object', ->
      expect(dictionary_item.save()).toBe('saved object')

    it 'should call DqxItems.DataStorage.set with key and self', ->
      dictionary_item.save()
      expect(DqxItems.DataStorage.set).toHaveBeenCalledWith('paramedKey',dictionary_item)


  describe '#destroy()', ->

    dictionary_item = undefined

    beforeEach ->
      DqxItems.DictionaryItem.dictionary_key = 'dictionary_key'
      spyOn(DqxItems.DataStorage, 'destroy')
      dictionary_item = new DqxItems.DictionaryItem(
        {name:'アイテム名',kana:'あいてむめい',type:'test',key:'paramedKey'}
      )

    it 'should return key of destroyed item', ->
      expect(dictionary_item.destroy()).toBe('paramedKey')

    it 'should call DqxItems.DataStorage.destroy with key and self', ->
      dictionary_item.destroy()
      console.dir dictionary_item.get('key')
      expect(DqxItems.DataStorage.destroy).toHaveBeenCalledWith('paramedKey')


  describe '.findByKey()', ->

    beforeEach ->
      @fetched_hash = {name:'アイテム名',kana:'あいてむめい',type:'test'}
      DqxItems.DictionaryItem.dictionary_key = 'dictionary_key'
      spyOn(DqxItems.DataStorage, 'get').andReturn(@fetched_hash)
      spyOn(DqxItems.CodeGenerator,'generate').andReturn('generated_code')
      @finded = DqxItems.DictionaryItem.findByKey('param string')

    afterEach ->
      DqxItems.DictionaryItem.dictionary_key = DqxItems.CodeGenerator.generate("dictionaries")

    it 'should call DqxItems.DataStorage.get with key', ->
      expect(DqxItems.DataStorage.get).toHaveBeenCalledWith('param string')

    it 'should return with DqxItems.DictionaryItem', ->
      expect(typeof @finded).toBe('object')
      expect(@finded.constructor.name).toBe("DictionaryItem")
      expect(@finded.get('name')).toBe('アイテム名')
      expect(@finded.get('kana')).toBe('あいてむめい')
      expect(@finded.get('type')).toBe('test')
      expect(@finded.get('key')).toBe('dictionary_key' + 'generated_code')


  describe '.findByName()', ->

    beforeEach ->
      DqxItems.DictionaryItem.dictionary_key = 'dictionary_key'
      spyOn(DqxItems.DictionaryItem, 'findByKey').andReturn('finded_item')
      spyOn(DqxItems.CodeGenerator,'generate').andReturn('generated_code')

    afterEach ->
      DqxItems.DictionaryItem.dictionary_key = DqxItems.CodeGenerator.generate("dictionaries")

    it 'should return with finded item', ->
      expect(DqxItems.DictionaryItem.findByName('アイテム名')).toBe('finded_item')

    it 'should call DqxItems.DictionaryItem.findByKey with generated key', ->
      DqxItems.DictionaryItem.findByName('アイテム名')
      expect(DqxItems.DictionaryItem.findByKey).toHaveBeenCalledWith(
        'dictionary_key' + 'generated_code'
      )

    it 'should call DqxItems.CodeGenerator.generate with param string', ->
      DqxItems.DictionaryItem.findByName('param string')
      expect(DqxItems.CodeGenerator.generate).toHaveBeenCalledWith(
        'param string'
      )

