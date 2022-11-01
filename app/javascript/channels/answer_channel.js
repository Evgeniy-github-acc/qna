import consumer from "./consumer"
var answer_template = require("../../assets/templates/partials/answer.hbs")

if (typeof(gon.current_user) !== 'undefined') {
  var current_user_id = gon.current_user.id
}

function ready(){
  consumer.subscriptions.create({ channel:"AnswerChannel", question_id: gon.question_id }, {
    connected() {
      console.log('Connected to AnswerChannel')
      this.perform("follow", { question_id: gon.question_id } )
    },

    received(data) {
      var answer = JSON.parse(data)
      if (typeof(gon.current_user) == 'undefined' || gon.current_user.id !== answer.author.id ){
        $('.answers').append(answer_template({answer: answer, current_user_id: current_user_id}))
      }
    }
  })
}
document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)
