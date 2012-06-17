module SitesHelper
  def site_locations_array( sites )
    sites = [ sites ] unless sites.is_a? Enumerable

    sites.map{ |s| [ s.latitude, s.longitude ] }.to_json
  end

  def map_canvas( sites, editable, latitude = nil, longitude = nil )
    data = {
      locations: site_locations_array( sites ),
      editable: editable.to_s
    }

    if latitude and longitude
      data[ :current_location ] = [ latitude.to_f, longitude.to_f ]
    end

    content_tag( :div, '', id: 'map_canvas', data: data )
  end
end
