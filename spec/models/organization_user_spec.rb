require 'spec_helper'

describe OrganizationUser do
  describe 'validations' do
    before :each do
      @organization_user = FactoryGirl.build( :organization_user )
    end

    it 'is valid with valid attributes' do
      @organization_user.should be_valid
    end

    it 'should not be valid with missing user' do
      @organization_user.user = nil
      @organization_user.should_not be_valid
    end
  end

  describe 'email' do
    before :each do
      @organization = FactoryGirl.create( :organization, :with_user )
    end

    it 'should set email on initialize' do
      @organization.reload
      @organization.organization_users.first.email.should == @organization.organization_users.first.user.email
    end

    it 'should find user by email on save' do
      user = FactoryGirl.create( :user )
      org_user = @organization.organization_users.first
      
      org_user.email = user.email
      @organization.save

      @organization.organization_users.first.user.should == user
    end

    it 'should not change user if set directly' do
      user1, user2 = FactoryGirl.create_list( :user, 2 )
      org_user = @organization.organization_users.first
      
      org_user.user = user2
      org_user.email = user1.email

      @organization.save
      @organization.organization_users.first.user.should == user2
    end

    it 'should set error of user not found when not found' do
      @organization.organization_users.first.email = 'notfound@example.com'
      @organization.should_not be_valid
    end
  end

  describe 'cleanup_roles' do
    it 'should remove blanks from roles' do
      organization = FactoryGirl.create( :organization, :with_user )

      organization.organization_users.first.roles = [ 'Administrator', '' ]
      organization.save

      organization.organization_users.first.roles.should =~ [ 'Administrator' ]
    end
  end
end
