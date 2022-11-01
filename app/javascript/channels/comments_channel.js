import consumer from "./consumer"

if (typeof(gon.current_user) !== 'undefined') {
  var current_user_id = gon.current_user.id
}

function ready(){
  consumer.subscriptions.create({channel: "CommentsChannel", question_id: gon.question_id}, {
    connected() {
      this.perform("follow", { question_id: gon.question_id } )
    },

    received(data) {
      var comment_template = require("../../assets/templates/partials/comment.hbs")
      var comment = JSON.parse(data)
      var commentable_instance = comment.commentable_type.toLowerCase()
      if (commentable_instance == 'answer') {
        var commentsList = $(`#${commentable_instance}-${comment.commentable_id} .${commentable_instance}-comments`)
      } else {
        var commentsList = $(`.${commentable_instance}[item-id='${comment.commentable_id}'] .${commentable_instance}-comments`)
      }
      
      if (typeof(gon.current_user) == 'undefined' || gon.current_user.id !== comment.author.id ){
        commentsList.append(comment_template({comment: comment, current_user_id: current_user_id}))
      }
    }
  });
}
document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)
