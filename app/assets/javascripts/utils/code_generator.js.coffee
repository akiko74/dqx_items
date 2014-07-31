window.DqxItems.Utils.CodeGenerator = class CodeGenerator

  @generate = (source) ->
    return CryptoJS.SHA1(source).toString()
