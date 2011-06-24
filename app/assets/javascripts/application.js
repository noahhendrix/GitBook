// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  var $events = $('.event');
  
  //touch event to focus it
  $events.click(function(){
    $events.removeClass('focused');
    $(this).addClass('focused');
  });
  
  //keyboard navigation through events
  $(document.documentElement).keyup(function(event) {
    var $selected = $events.filter('.focused').first();
    if ($selected.length == 0)
      $selected = $events.first();

    $selected.removeClass('focused');
    
    var $next;
    
    if (event.keyCode == 74 || event.keyCode == 40)
      $next = $selected.next('.event');
    if (event.keyCode == 75 || event.keyCode == 38)
      $next = $selected.prev('.event');
      
    $next.addClass('focused');
    $.scrollTo(($next), {
      duration: 500
    });
  });
});