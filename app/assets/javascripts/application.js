// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require twitter/bootstrap
//= require_tree .

function prepare_dom()
{
	/* Set list or month view */
    if($('#list-btn').attr('class') == "btn btn-warning active") {
	    $('#month-view').hide();
	}
	else
	{
	    $('#list-view').hide();
	}
  
	/* Hide event button control */
	$(".delete-btn").hide();
	$(".edit-btn").hide();
	/* Set event hover */
	$(".event-section > .event").hover(function(){
		$(this).find(".delete-btn").slideDown(100);
		$(this).find(".edit-btn").slideDown(100);
	},function(){
    	$(this).find(".delete-btn").slideUp(100);
		$(this).find(".edit-btn").slideUp(100);
  	});	

	/* Set view control */
	$('#list-btn').click(function(){
		$('#month-view').slideUp(1000);
		$('#list-view').slideDown(1000);
	});
	
	$('#month-btn').click(function(){
		$('#list-view').slideUp(500);
		$('#month-view').slideDown(500);
	});
	
	
	$(".contact-pick").click(function(){
		if($(this).hasClass('active')){
			$(this).parent().parent().parent().fadeTo('slow', 1);
			$(this).attr('value','Remove');
		}
		else{
			$(this).parent().parent().parent().fadeTo('slow', 0.3);
			$(this).attr('value','Restore');
		}
	});
	
};

$(document).ready(function()
{
   $('#list-btn').button('toggle')
   prepare_dom();
});

function set_notice_fadeout()
{
	$(".fadeout").delay(2000).fadeOut(1000);
}




