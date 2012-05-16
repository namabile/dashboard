# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$("#refresh-button").bind "click", (event) => location.reload(true)
	$(".table").tablesorter()
	$(".date-input").datepicker();

	$("#date-form")
		.bind "ajax:beforeSend", (event) => $("#orders-container").spin()
		.bind "ajax:complete", (event) => $("#orders-container").spin(false)