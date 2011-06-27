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
    
    $events.trigger('unfocused');
    $(this).trigger('focused');
    
  }).live('focused', function(){
    
    $(this).addClass('focused');
    $.scrollTo(this, { duration: 500 });
    
  }).live('unfocused', function(){
    
    $(this).removeClass('focused');
    
  }).trigger('unfocused').first().addClass('focused');
  
  //keyboard navigation through events
  $(document.documentElement).keyup(function(event) {
    valid_keycodes = new Array(38, 40, 74, 75);
    if ($.inArray(event.keyCode, valid_keycodes) == -1 || $(event.target).is(':input'))
      return;
    
    var $selected = $events.filter('.focused').first();
    var $next;
    
    if ($selected.length == 0)
      $selected, $next = $events.first();
    else {
      if (event.keyCode == 74 || event.keyCode == 40)
        $next = $selected.next('.event');
      if (event.keyCode == 75 || event.keyCode == 38)
        $next = $selected.prev('.event');
    }
    
    $selected.trigger('unfocused');
    $next.trigger('focused');
  });
});