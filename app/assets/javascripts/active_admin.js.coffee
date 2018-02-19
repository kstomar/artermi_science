#= require active_admin/base
$(document).ready ->
  setInterval (->
    $.ajax
      url: '/admin/admin_users/progress'
    return
  ), 3000
