readyPage = ->

  $("#entry_project_id_or_name").selectize
    create: true
    sortField: "text"
  
  $("#entry_minutes").focus()

  $("#entry_minutes").on "blur", ->
    if $(this).val() is ""
      $(".entry-save").val("Start")
    else
      $(".entry-save").val("Save")

  current_seconds = $("#clocking").data("starting-minutes")
  if current_seconds
    $('#runner').runner
      milliseconds: false
      startAt: current_seconds * 1000

    $('#runner').runner('start')
  else
    $('#runner').runner
      milliseconds: false
  end  
    
$(document).ready readyPage
$(document).on "page:load", readyPage

window.reset_page = readyPage