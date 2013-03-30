#my_items_form_builder.js.coffee
window.DqxItems.MyItemsFormBuilder = class MyItemsFormBuilder

  debug_log = (method_name='',message) ->
    DqxItems.Logger.debug("[DqxItems.MyItemsFormBuilder#{method_name}] ", message)

  @my_items_form_id: "#my_items_update_form"
    
  @bind_functions = () ->
    debug_log ".bind_functions()", "--- Start ---"
    jQuery(@my_items_form_id).bind "submit", submit_at_my_items_form
    debug_log ".bind_functions()", DqxItems.Dictionary.all()
    debug_log ".bind_functions()", "--- End ---"

  submit_at_my_items_form = (e) ->
    debug_log "#submit_at_my_items_form()", "--- Start ---"
    e.preventDefault()
    debug_log "#submit_at_my_items_form()", "--- End ---"
    return false
