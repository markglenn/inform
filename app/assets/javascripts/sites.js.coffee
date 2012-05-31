# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  if navigator.geolocation 
    $('a#near-me-link').click ->
      navigator.geolocation.getCurrentPosition(
        (p) -> 
          link = $('a#near-me-link')
          location.href = "#{link.attr('href')}/#{encodeURI(p.coords.latitude)}/#{encodeURI(p.coords.longitude)}/#{encodeURI(p.coords.accuracy)}"
        (p) -> 
          if p.code == p.POSITION_UNAVAILABLE
            alert 'Current position is unavailable on this device'
        { enableHighAccuracy: true }
      )
      false
