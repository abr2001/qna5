$ ->
  appendComment = (data) ->
    if gon.user_id != data['comment']['user_id']
      if data['comment']['commentable_type'] == 'Question'
        $('.list-comment-question').html(data['html'])
      if data['comment']['commentable_type'] == 'Answer'
        $('#list-comment-answer-' + data['comment']['commentable_id']).html(data['html'])

  App.cable.subscriptions.create "CommentsChannel", {
    connected: ->
      @follow()

    follow: ->
      @perform 'follow'

    received: (data) ->
      appendComment(data)
  }
