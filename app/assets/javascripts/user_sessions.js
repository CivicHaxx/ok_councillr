// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("ready page:load", function() {
	setTimeout(function() {
		$("header").find("[data-alert]").fadeOut(600);
	}, 5000);
});
