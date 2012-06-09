addMarker = ( location, moveable = true ) ->
  marker = $('#map_canvas').data( 'marker' )
  marker.setMap( null ) if marker

  $('#site_latitude').val location.lat()
  $('#site_longitude').val location.lng()

  $('#map_canvas').data( 
    'marker'
    new google.maps.Marker
      position: location
      map: $('#map_canvas').data('map')
      draggable: moveable
      animation: google.maps.Animation.DROP
  )

  if moveable
    google.maps.event.addListener( $('#map_canvas').data('marker'), "dragend", (event) ->
      $('#site_latitude').val( event.latLng.lat() )
      $('#site_longitude').val( event.latLng.lng() )
    )

mapInitialize = ->
  lat = $('#map_canvas').data('lat')
  lng = $('#map_canvas').data('lng')
  hasMarker = $('#map_canvas').data('withmarker')
  editable = $('#map_canvas').data('editable')

  mapOptions = 
    center: new google.maps.LatLng(lat,lng)
    zoom: if hasMarker then 16 else 12 
    mapTypeId: google.maps.MapTypeId.ROADMAP

  $('#map_canvas').data('map', new google.maps.Map( 
    document.getElementById( 'map_canvas' )
    mapOptions 
  ))

  if editable
    google.maps.event.addListener($('#map_canvas').data('map'), "rightclick", (event) ->
      addMarker event.latLng
    )

  addMarker( new google.maps.LatLng(lat,lng), editable ) if hasMarker

$ ->
  mapInitialize( )

  $('#map-search').submit ->
    geocoder = new google.maps.Geocoder()
    map = $('#map_canvas').data('map')

    geocoder.geocode( 
      { address: $('#map-search-box').val( ) }
      ( results, status ) ->
        if ( status == google.maps.GeocoderStatus.OK )
          map.panTo results[ 0 ].geometry.location
          map.setZoom 15

          addMarker results[ 0 ].geometry.location
    )

    false
