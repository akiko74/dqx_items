window.DqxItems.CodeGenerator = class CodeGenerator

  @generate = (source) ->
    return CryptoJS.SHA1(source).toString()
