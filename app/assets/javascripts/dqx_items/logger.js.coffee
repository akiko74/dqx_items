window.DqxItems.Logger = class Logger

  @debug = (_prefix, message) ->
    if typeof message == "string"
      console.log _prefix + message
    else if jQuery.isArray(message)
      console.log _prefix + "++++++++++++++++++++++++"
      console.log " Length: #{message.length}"
      console.log "+ + + + + + + + + + + + + + + + + + + + + + + + + + + +"
      for row in message
        console.log row
      console.log "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    else
      console.log _prefix + "++++++++++++++++++++++++"
      console.log message
      console.log "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"

