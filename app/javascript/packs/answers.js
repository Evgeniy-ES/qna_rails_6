$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
});


$(document).on('ajax:success', '.destroy-answer-link', function(e){
 var answerId = $(this).data('answerId');
 $(this).parentsUntil('.answers').remove();
});
