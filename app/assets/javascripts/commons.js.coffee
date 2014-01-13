$ ->
  $(".navbar-form #regist-button").bind 'click', (e) ->
    e.preventDefault()
    window.location = "/users/sign_up"
    return false
