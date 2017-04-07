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
    if $(this).find('.current-user-rate-answer').attr("rate") == "0"
      $(this).find('.btn-cancel-rate-answer').hide();


  $('.btn-rate-answer').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    answer = $('#answer-' + response.id)
    $(answer).find('.rating-answer').html(response.rating)
    $(answer).find('.current-user-rate-answer').html(response.rate)
    $(answer).find('.btn-cancel-rate-answer').show();
    $(answer).find('.rate-answer-errors').html('');

  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response.errors, (index, value) ->
      answer = $('#answer-' + response.id)
      $(answer).find('.rate-answer-errors').html(value)

  $('.btn-cancel-rate-answer').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    answer = $('#answer-' + response.id)
    $(answer).find('.rating-answer').html(response.rating);
    $(answer).find('.current-user-rate-answer').html(response.rate);
    $(answer).find('.btn-cancel-rate-answer').hide();
    $(answer).find('.rate-answer-errors').html('');

