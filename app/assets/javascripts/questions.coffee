# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

  $('.btn-rate-question').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.rating-question').html(response.rating)
    $('.current-user-rate-question').html(response.rate)
    $('.btn-cancel-rate-question').show();
    $('.rate-question-errors').html('');

  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.rate-question-errors').html(value)

  if $('.current-user-rate-question').attr("rate") == "0"
    $('.btn-cancel-rate-question').hide();

  $('.btn-cancel-rate-question').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.rating-question').html(response.rating);
    $('.current-user-rate-question').html(response.rate);
    $('.btn-cancel-rate-question').hide();
    $('.rate-question-errors').html('');
