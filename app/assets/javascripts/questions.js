var App = App = {}
App.cable = ActionCable.createConsumer()



App.cable.subscriptions.create('QuestionsChannel', {
  connected: function(data) {
      console.log(data)
      this.perform('follow')
  },

  received: function(data) {
    console.log(data)
    var questions = document.querySelector('.questions')

    if (questions) { questions.insertAdjacentHTML('afterend', data) }
  }

})
