var App = App = {}
App.cable = ActionCable.createConsumer()



App.cable.subscriptions.create('CommentsChannel', {
  connected: function() {
    var q = window.location.pathname.split('/')[2];
    this.perform('follow', { question_id: q });
  },

  received: function(data) {
    $('#' + data['model_name'] + '-' + 'comments-' + data['model_id']).append(data['body'])
  }

})
