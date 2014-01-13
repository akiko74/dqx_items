window.DqxItems.Logger = class Logger

  @debug = (_prefix, message) ->
    date = new Date()
    date_string = date.getFullYear()  + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() + "." + date.getMilliseconds()

    if typeof message == "string"
      console.log date_string + " " + _prefix + message
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

