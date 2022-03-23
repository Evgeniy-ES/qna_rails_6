$(document).on('turbolinks:load', function(){
  $('.edit-answer-link').on('click', function(e) {
    e.prevntDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
});
