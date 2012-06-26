require 'spec_helper'

feature 'Site browsing', slow: true do
  background do
    @site = FactoryGirl.create( :site )
  end

  scenario 'See all sites' do
    visit( sites_path )
    find( :xpath, '//h2[1]' ).should have_content @site.title
  end

  scenario 'View single site' do
    visit( sites_path )
    find( "h2" ).click_link( @site.title )

    find( 'h1' ).should have_content @site.title
    page.should have_content @site.description
  end
end
