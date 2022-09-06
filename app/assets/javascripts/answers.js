var App = App = {}
App.cable = ActionCable.createConsumer()

App.cable.subscriptions.create('AnswersChannel', {

  connected: function() {
    var q = window.location.pathname.split('/')[2];
    this.perform('follow', { question_id: q });
  },

  received: function(data) {
    console.log('asaa')
    $('#answers-' + data['question_id']).append(data['body'])

  }

})


$(document).on('turbolinks:load', function(){
  $('.edit-answer-link').on('click', function(e) {
     e.preventDefault();
     $(this).hide();
     var answerId = $(this).data('answerId');
     $('form#edit-answer-' + answerId).removeClass('hidden')
  })
  $('form.new-answer').on('ajax:success', function(e) {
  })

    .on('ajax:error', function(e) {
      var errors = e.detail[0]
      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>')
      })
      })
})
