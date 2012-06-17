setLocation = ( location ) ->
  # Set the textbox values to the location
  $('#site_latitude').val location.lat()
  $('#site_longitude').val location.lng()

addMarker = ( location, bounds = false, moveable = false ) ->
  $('#map_canvas').gmap('clear', 'markers') if moveable

  marker = $('#map_canvas').gmap( 'addMarker' 
    position: location.join()
    animation: google.maps.Animation.DROP
    bounds: bounds
    draggable: moveable
  )

  return unless moveable

  # Add drag event if the marker is movable
  marker.dragend( ( e ) -> 
    setLocation e.latLng
  )

$ ->
  map = $('#map_canvas')
  locations = map.data('locations')
  moveable = map.data('editable') || false

  map.gmap(
    center: if locations then locations[ 0 ].join() else '42,-88'
    zoom: if map.data('withmarker') then 16 else 12
    mapTypeId: google.maps.MapTypeId.ROADMAP
  )

  if map.data( 'withmarker' )
    $.each locations, ( i, location ) -> 
      addMarker location, locations.length > 1, moveable

  $('#map-search').submit ->
    contents = $( '#map-search-box' ).val( )

    $('#map_canvas').gmap( 'search'
      address: $( '#map-search-box' ).val( )
      ( results, status ) -> 
        if status == 'OK'
          location = results[ 0 ].geometry.location
          $('#map_canvas').gmap('get', 'map').panTo location
          setLocation location
          addMarker [ location.lat(), location.lng() ], false, true
    )

    # Don't actually submit
    false
