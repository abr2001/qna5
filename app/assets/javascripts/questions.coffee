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
    $('.rate-question').find('.rating').html(response.rating)
    $('.rate-question').find('.current-user-rate').html(response.rate)
    $('.rate-question').find('.btn-cancel-rate').show();
    $('.rate-question').find('.rate-errors').html('');

  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response.errors, (index, value) ->
      $('.rate-question').find('.rate-errors').html(value)

  if $('.rate-question').find('.current-user-rate').attr("rate") == "0"
    $('.rate-question').find('.btn-cancel-rate').hide();

  $('.btn-cancel-rate').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.rate-question').find('.rating').html(response.rating);
    $('.rate-question').find('.current-user-rate').html(response.rate);
    $('.rate-question').find('.btn-cancel-rate').hide();
    $('.rate-question').find('.rate-errors').html('');

  App.cable.subscriptions.create "QuestionsChannel", {
    connected: ->
      @follow()

    follow: ->
      @perform 'follow'

    received: (data) ->
      $(".questions-list").append data['question']
  }

