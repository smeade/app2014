readyPage = ->

  tinymce.init({
  	selector:'#note_content'
  });

$(document).ready readyPage
$(document).on "page:load", readyPage
