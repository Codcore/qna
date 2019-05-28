# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App.cable.subscriptions.create('CommentariesChannel', {
  connected: ->
    @perform 'follow', question_id: gon.question_id
    ,

  received: (data) ->
    if data.commentary.user_id != gon.user_id
      resourceType = data.commentary.commentable_type.toLowerCase()
      commentarySelector =
        if resourceType == 'question'
        then $('.question .commentaries')
        else $('#answer-' + data.commentary.commentable_id + ' .commentaries')
      commentarySelector.append(JST['commentary'](commentary: data.commentary))
    console.log(data)
    console.log(commentarySelector)
  })