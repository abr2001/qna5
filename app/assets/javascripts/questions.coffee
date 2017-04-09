# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

  $('.btn-rate').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.rating').html(response.rating)
    $('.current-user-rate').html(response.rate)
    $('.btn-cancel-rate').show();
    $('.rate-errors').html('');

  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response.errors, (index, value) ->
      $('.rate-errors').html(value)

  if $('.current-user-rate').attr("rate") == "0"
    $('.btn-cancel-rate').hide();

  $('.btn-cancel-rate').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.rating').html(response.rating);
    $('.current-user-rate').html(response.rate);
    $('.btn-cancel-rate').hide();
    $('.rate-errors').html('');
