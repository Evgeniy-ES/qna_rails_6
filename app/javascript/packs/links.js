$(document).on('ajax:success', '.destroy-link-link', function(e){
 var linkId = $(this).data('linkId');
 $(this).parentsUntil('.links').remove();
});
