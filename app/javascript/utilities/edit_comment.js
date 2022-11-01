$(document).on('turbolinks:load', function(){
  $(".comment").on('click', '.edit-comment-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var commentId = $(this).data('commentId');
    $('form#edit-comment-' + commentId).removeClass('hidden');
  })
});