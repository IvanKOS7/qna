$(document).on('turbolinks:load', function(){
  $('.vote').on('click', function(e) {

    $('.vote').on('ajax:success', function(e) {
      var model = e.detail[0]
      $('.points').text(model)

    })
    .on('ajax:error', function(e) {
      var errors = e.detail[0]

      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>')
      })
      })
  })
})
