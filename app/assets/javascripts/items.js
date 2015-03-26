$('.item-body').fadeIn('slow');

$(document).foundation({
  accordion: {
    content_class: 'content',
    active_class: 'active',
    multi_expand: true,
    toggleable: true
  }
});

$(".yes").click(function(){
	$('.item-body').animate({
		"left": "+=2000px"
	});
});

$(".no").click(function(){
	$('.item-body').animate({
		"left": "-=2000px"
	});
});

$(".skip").click(function(){
	$('.item-body').animate({
		"top": "+=2000px"
	});
});

$(".next").click(function(){
	$('.item-body').animate({
		"left": "+=2000px"
	});
});