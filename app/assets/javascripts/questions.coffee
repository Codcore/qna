# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow'
  ,

  received: (data) ->
    console.log(data)
    console.log(JST["question"](data))
    $('table').append JST["question"](data)
})
