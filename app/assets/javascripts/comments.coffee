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
    return if $("#comment-#{data.comment.id}")[0]?
    if data.comment.commentable_type == 'Question'
      $('.list-comment-question').append(data['html'])
    if data.comment.commentable_type == 'Answer'
      $('#list-comment-answer-' + data.comment.commentable_id).append(data['html'])

  App.cable.subscriptions.create "CommentsChannel", {
    connected: ->
      @follow()

    follow: ->
      return unless gon.question_id
      @perform 'follow', id: gon.question_id

    received: (data) ->
      appendComment(data)
  }
