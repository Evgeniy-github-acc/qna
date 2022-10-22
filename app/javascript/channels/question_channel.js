import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
  connected() {
    console.log('Connected to QuestionChannel')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.questions').append(data)
      },
});
