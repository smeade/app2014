readyPage = ->
  $("#entry_project_id_or_name").selectize
    create: true
    sortField: "text"
  
  $("#entry_minutes").focus()

  $("#entry_minutes").on "blur", ->
    if $(this).val() is ""
      console.log("empty")
      $(".entry-save").val("Start")
    else
      $(".entry-save").val("Save")

  console.log('reset')

$(document).ready readyPage
$(document).on "page:load", readyPage

window.reset_page = readyPage