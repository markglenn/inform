require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SitesHelper. For example:
#
# describe SitesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe SitesHelper do
  describe 'site_locations_array' do
    it 'should return location for site' do
      site = FactoryGirl.create( :site, latitude: 1, longitude: 2 )
      helper.site_locations_array([ site ]).should == "[[1,2]]"
    end
  end
end
