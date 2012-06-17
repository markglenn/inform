module SitesHelper
  def site_locations_array( sites )
    sites.map{ |s| [ s.latitude, s.longitude ] }.to_json
  end

end
