$(document).on('turbolinks:load', function(){
  $(".question-comments").on('click', '.edit-comment-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var commentId = $(this).data('commentId');
    $('form#edit-comment-' + commentId).removeClass('hidden');
  })
});