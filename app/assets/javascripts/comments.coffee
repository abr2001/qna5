$ ->
  $('.add-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.comment-question').show();

  $('.cancel-question-comment-link').click (e) ->
    e.preventDefault();
    $('.comment-question').hide();
    $('.add-comment-link').show();

  $('.add-answer-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#comment-answer-' + answer_id).show();

  $('.cancel-answer-comment-link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId');
    $('#add-answer-comment-link-'+ answer_id).show();
    $('form#comment-answer-' + answer_id).hide();

  appendComment = (data) ->
    return if gon.user_id == data['comment']['user_id']
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
      console.log(data)
      appendComment(data)
  }
