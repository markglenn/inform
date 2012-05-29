require 'spec_helper'

describe Site do
  describe 'validations' do
    before :each do 
      @site = FactoryGirl.build( :site )
    end

    it 'should be valid with valid attributes' do
      @site.should be_valid
    end

    it 'should be invalid with missing title' do
      @site.title = nil
      @site.should_not be_valid
    end

    it 'should be invalid with missing latitude' do
      @site.latitude = nil
      @site.should_not be_valid
    end

    it 'should be invalid with missing longitude' do
      @site.longitude = nil
      @site.should_not be_valid
    end
  end

  describe 'latitude/longitude' do
    it 'should set location data on save' do
      site = FactoryGirl.create( :site, latitude: 123, longitude: 45 )
      site.location.should == { lng: 45, lat: 123 }
    end

    it 'should set latitude and longitude on load' do
      FactoryGirl.create( :site, latitude: 123, longitude: 45 ).id
      site = Site.first

      site.latitude.should == 123
      site.longitude.should == 45
    end
  end
end
