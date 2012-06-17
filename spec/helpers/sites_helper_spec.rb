require 'spec_helper'

describe SitesHelper do
  describe 'site_locations_array' do
    it 'should return location for site' do
      site = FactoryGirl.create( :site, latitude: 1, longitude: 2 )
      helper.site_locations_array([ site ]).should == "[[1,2]]"
    end

    it 'should set site locations' do
      site = FactoryGirl.create( :site, latitude: 1, longitude: 2 )
      helper.site_locations_array(site).should == "[[1,2]]"
    end

  end

  describe 'map_canvas' do
    before :each do
      @site = FactoryGirl.create( :site, latitude: 1, longitude: 2 )
    end

    it 'should set site locations for single site' do
      helper.map_canvas(@site, false).should =~ /data-locations=\"\[\[1,2\]\]\"/
    end

    it 'should set editable' do
      helper.map_canvas([@site], false).should =~ /data-editable=\"false\"/
      helper.map_canvas([@site], true).should =~ /data-editable=\"true\"/
    end

    it 'should set current location if given' do
      helper.map_canvas([@site], false, "3", "4").should =~ /data-current-location=\"\[3.0,4.0\]\"/
    end

    it 'should set id of map' do
      helper.map_canvas([@site], false).should =~ /id=\"map_canvas\"/
    end
  end
end
