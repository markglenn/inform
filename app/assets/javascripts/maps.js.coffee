setLocation = ( location ) ->
  # Set the textbox values to the location
  $('#site_latitude').val location.lat()
  $('#site_longitude').val location.lng()

addMarker = ( location, moveable = true ) ->
  # Clear any previous marker
  marker = $('#map_canvas').data( 'marker' )
  marker.setMap( null ) if marker

  setLocation( location )

  # Add a marker to the map
  $('#map_canvas').data( 
    'marker'
    new google.maps.Marker
      position: location
      map: $('#map_canvas').data('map')
      draggable: moveable
      animation: google.maps.Animation.DROP
  )

  # Add drag event if the marker is movable
  if moveable
    google.maps.event.addListener( 
      $('#map_canvas').data('marker')
      "dragend"
      (event) -> setLocation event.latLng
    )

mapInitialize = ->
  # Get starting location
  location = new google.maps.LatLng( 
    $('#map_canvas').data('lat')
    $('#map_canvas').data('lng')
  )
  hasMarker = $('#map_canvas').data('withmarker')
  editable = $('#map_canvas').data('editable')

  # Google Maps options
  mapOptions = 
    center: location
    zoom: if hasMarker then 16 else 12 
    mapTypeId: google.maps.MapTypeId.ROADMAP

  # Create the map
  $('#map_canvas').data(
    'map'
    new google.maps.Map( 
      document.getElementById( 'map_canvas' )
      mapOptions 
    )
  )

  # Add a right click event to add a marker
  if editable
    google.maps.event.addListener(
      $('#map_canvas').data('map')
      "rightclick" 
      (event) -> addMarker event.latLng
    )

  # Add a marker if requested
  addMarker( location, editable ) if hasMarker

$ ->
  mapInitialize( ) if $('#map_canvas').length > 0

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

    # Don't actually submit
    false
