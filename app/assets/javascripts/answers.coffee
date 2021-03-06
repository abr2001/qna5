# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  $('.answers').children().each ->
    if $(this).find('.current-user-rate').attr("rate") == "0"
      $(this).find('.btn-cancel-rate').hide();

  $('.btn-rate').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    answer = $('#answer-' + response.id)
    $(answer).find('.rating').html(response.rating)
    $(answer).find('.current-user-rate').html(response.rate)
    $(answer).find('.btn-cancel-rate').show();
    $(answer).find('.rate-errors').html('');

  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response.errors, (index, value) ->
      answer_id = e.currentTarget.dataset['ratableId']
      answer = $('#answer-' + answer_id)
      $(answer).find('.rate-errors').html(value)

  $('.btn-cancel-rate').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    answer = $('#answer-' + response.id)
    $(answer).find('.rating').html(response.rating);
    $(answer).find('.current-user-rate').html(response.rate);
    $(answer).find('.btn-cancel-rate').hide();
    $(answer).find('.rate-errors').html('');


  appendAnswer = (data) ->
    return if $("#answer-#{data.answer.id}")[0] != undefined
    $(".answers").append JST["templates/answer"](data)

  App.cable.subscriptions.create "AnswersChannel", {
    connected: ->
      @follow()

    follow: ->
      return unless gon.question_id
      @perform 'follow', id: gon.question_id

    received: (data) ->
      appendAnswer(data)
  }
