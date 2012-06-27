require 'spec_helper'

describe OrganizationUsersController do
  describe 'GET index' do
    before :each do
      @organization = FactoryGirl.create( :organization_with_user )
    end

    it 'should set organization' do
      get :index, organization_id: @organization.to_param
      assigns( :organization ).should == @organization
    end
  end

  describe 'GET show' do
    before :each do
      @user = FactoryGirl.create( :user )
      ou = FactoryGirl.build( :organization_user, user: @user )
      @organization = FactoryGirl.create( :organization, organization_users: [ ou ] )
    end

    it 'show set organization' do
      get :show, organization_id: @organization.to_param, id: @user.id
      assigns( :organization ).should == @organization
    end

    it 'show set organization_user' do
      get :show, organization_id: @organization.to_param, id: @user.id
      assigns( :organization_user ).user.should == @user
    end

  end
end
