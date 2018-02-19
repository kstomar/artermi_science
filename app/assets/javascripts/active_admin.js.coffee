#= require active_admin/base
$(document).ready ->
  progress_interval = setInterval((->
    check_progress()
    return
  ), 2000)

check_progress = ->
  if $('#zip-created').data('check') == false
    $.ajax url: '/admin/admin_users/progress'
  return
