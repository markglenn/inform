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

  # Set some values and defaults from the data attributes
  locations = map.data('locations') || []
  moveable  = map.data('editable') || false
  center    = map.data( 'current-location' ) || if locations.length > 0 then locations[ 0 ] else [42,-88]
  zoom      = if map.data('current-location') then 13 else 16

  map.gmap(
    center: center.join()
    zoom: zoom
    mapTypeId: google.maps.MapTypeId.ROADMAP
  )

  # Add markers
  $.each locations, ( i, location ) -> 
    addMarker location, locations.length > 1, moveable

  # Map search form
  $('#map-search').submit ->

    $('#map_canvas').gmap( 'search'
      address: $( '#map-search-box' ).val( )
      ( results, status ) -> 
        return unless status == 'OK'

        location = results[ 0 ].geometry.location
        $('#map_canvas').gmap('get', 'map').panTo location
        setLocation location
        addMarker [ location.lat(), location.lng() ], false, true
    )

    # Don't actually submit
    false
