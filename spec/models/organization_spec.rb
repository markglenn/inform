require 'spec_helper'

describe Organization do
  describe 'validations' do

    let( :organization ){ FactoryGirl.build( :organization ) }

    it 'should be valid with valid attributes' do
      organization.should be_valid
    end

    it 'should not be valid with missing name' do
      organization.name = nil
      organization.should_not be_valid
    end

    it 'should not be valid with duplicate name' do
      FactoryGirl.create( :organization, name: organization.name )
      organization.should_not be_valid
    end

    it 'should be invalid with description length > 3000' do
      organization.description = 'a' * 3001
      organization.should_not be_valid
    end

    it 'should not be valid with no users' do
      organization.organization_users = []
      organization.should_not be_valid
    end

    it 'should not be valid with missing admin' do
      organization.organization_users.first.roles = []
      organization.should_not be_valid
    end
  end

  describe 'organization_users' do
    before :each do
      @organization = FactoryGirl.build( :organization )
    end

    it 'should embed organization user' do
      organization_user = FactoryGirl.build( :organization_user )

      @organization.organization_users << organization_user
      @organization.save

      Organization.first.organization_users.should include organization_user
    end
  end

  describe 'for_user' do
    before :each do
      @user = FactoryGirl.create( :user )
    end

    it 'should return all organizations for a user' do
      organization = FactoryGirl.create( :organization, user: @user )

      Organization.for_user( @user ).to_a.should =~ [ organization ]
    end

    it 'should not return organizations for which the user is not assigned' do
      organization = FactoryGirl.create( :organization )

      Organization.for_user( @user ).should be_empty
    end

    it 'should return organizations that have the user id' do
      organization = FactoryGirl.create( :organization, user: @user )

      Organization.for_user( @user.id.to_s ).to_a.should =~ [ organization ]
    end

  end

  describe 'roles_for_user' do
    before :each do
      @user = FactoryGirl.create( :user )
    end

    it 'should return roles for user for users with no roles' do
      organization = FactoryGirl.create( :organization )
      organization.organization_users.create( user: @user, roles: [] )
      organization.roles_for_user( @user ).should =~ []
    end

    it 'should return roles for user for users with roles' do
      organization = FactoryGirl.create( :organization, user: @user, roles: [ 'Administrator', 'User' ] )
      organization.roles_for_user( @user ).should =~ %w( Administrator User )
    end

    it 'should return nil for users not in organization' do
      organization = FactoryGirl.create( :organization )
      organization.roles_for_user( @user ).should be_nil
    end
  end
end
