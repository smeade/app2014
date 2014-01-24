# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
readyPage = ->
  $("#entry_project_id").selectize
    create: true
    sortField: "text"
  $("#entry_minutes").focus()

$(document).ready readyPage
$(document).on "page:load", readyPage
