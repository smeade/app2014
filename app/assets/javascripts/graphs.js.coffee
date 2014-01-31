readyPage = ->
  $(".popoverable").popover()

$(document).ready readyPage
$(document).on "page:load", readyPage
