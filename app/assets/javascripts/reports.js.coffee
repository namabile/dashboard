# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$("#report-inputs > form")
		.bind "ajax:beforeSend", (event) => 
			$(".report-container").html("&nbsp")
			$(".report-container").spin()
		.bind "ajax:complete", (event) => $(".report-container").spin(false)
