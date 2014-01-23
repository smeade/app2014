# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
selectizeClient = ->
  $("#project_client_id_or_name").selectize
    create: true
    sortField: "text"

$(document).ready selectizeClient
$(document).on "page:load", selectizeClient
