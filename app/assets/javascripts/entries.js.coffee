readyPage = ->

  # See http://brianreavis.github.io/selectize.js/
  $("#entry_project_id_or_name").selectize
    create: true
    sortField: "text"

  # For convenience, set focus on time entry field  
  $("#entry_minutes").focus()

  # When time entry field loses focus,
  # set submit button text.
  $("#entry_minutes").on "blur", ->
    if $(this).val() is ""
      $(".entry-save").val("Start")
    else
      $(".entry-save").val("Save")

  # If there is a running entry, start the clock at startingseconds
  current_minutes = $("#clocking").data("starting-minutes")
  if current_minutes
    $('#runner').runner
      milliseconds: false
      startAt: current_minutes * 60 * 1000
      format: (value, oldFormatter) ->
        ( (value / 1000) / 60 / 60 ).toFixed(2)
    $('#runner').runner('start')
  else
    $('#runner').runner
      milliseconds: false
      format: (value, oldFormatter) ->
        ( (value / 1000) / 60 / 60 ).toFixed(2)

  # show/hide edit/delete links
  $("tr.entry").hover (->
    $(this).addClass "hover"
  ), ->
    $(this).removeClass "hover"
    
$(document).ready readyPage
$(document).on "page:load", readyPage

window.reset_page = readyPage