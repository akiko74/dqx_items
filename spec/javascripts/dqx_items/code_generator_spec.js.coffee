#= require dqx_items/code_generator

describe 'DqxItems.CodeGenerator', ->


  describe '.generate()', ->


    beforeEach ->
      mockCryptoJS = CryptoJS.SHA1('source string')
      spyOn(CryptoJS,'SHA1').andReturn(mockCryptoJS)

    it 'should return generated code', ->
      expect(DqxItems.CodeGenerator.generate('param')).toBe('1daf600c25217c309ef03b510e4c83cd70921b85')

    it 'should call CryptoJS.SHA1 with param string', ->
      DqxItems.CodeGenerator.generate('param')
      expect(CryptoJS.SHA1).toHaveBeenCalledWith('param')


