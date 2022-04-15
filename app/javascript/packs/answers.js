$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('form.new-answer').on('ajax:success', function(e){

    var answer = e.detail[0];

    $('.answers').append('<p>' + answer.text + '</p>');
  })
  .on('ajax:error', function(e) {
    var errors = e.detail[0];

    $.each(errors, function(index, value) {
      $('.answer-errors').append('<p>' + value + '</p>');
    })

  })
});


$(document).on('ajax:success', '.destroy-answer-link', function(e){
 var answerId = $(this).data('answerId');
 $(this).parentsUntil('.answers').remove();
});
