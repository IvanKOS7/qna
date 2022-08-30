var App = App = {}
App.cable = ActionCable.createConsumer()



App.cable.subscriptions.create('CommentsChannel', {
  connected: function() {
    this.perform('follow')
  },

  received: function(data) {
    console.log('dfvfdvds')
    console.log('#' + data['model_name'] + '-' + 'comments-' + data['model_id'])
    $('#' + data['model_name'] + '-' + 'comments-' + data['model_id']).append(data['body'])

  }

})
