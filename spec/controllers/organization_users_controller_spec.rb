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

  describe 'GET edit' do
    before :each do
      @user = FactoryGirl.create( :user )
      @ou = FactoryGirl.build( :organization_user, user: @user )
      @organization = FactoryGirl.create( :organization, organization_users: [ @ou ] )
    end

    it 'edit set organization' do
      get :edit, organization_id: @organization.to_param, id: @ou.to_param
      assigns( :organization ).should == @organization
    end

    it 'edit set organization_user' do
      get :edit, organization_id: @organization.to_param, id: @ou.to_param
      assigns( :organization_user ).user.should == @user
    end
  end

  describe 'PUT update' do
    describe 'with valid attributes' do

      before :each do
        @organization = FactoryGirl.create( :organization_with_user )
        @organization_user = @organization.organization_users.first
      end

      it 'updates the requested organization' do
        new_user = FactoryGirl.create( :user )
        OrganizationUser.any_instance.should_receive(:update_attributes).with({:user_id => new_user.id, roles: nil})
        put :update, { organization_id: @organization.to_param, id: @organization_user.to_param, email: new_user.email }
      end

      it 'should return error when user not found' do
        put :update, { organization_id: @organization.to_param, id: @organization_user.to_param, email: 'bad-email@example.com' }
        assigns( :organization_user ).errors.should_not be_empty
      end

      it 'should update roles for user' do
        user = @organization_user.user

        put :update, { 
          organization_id: @organization.to_param, 
          id: @organization_user.to_param, 
          email: user.email,
          roles: [ 'Administrator', 'Editor' ]
        }

        @organization.reload

        @organization.organization_users.first.roles.should =~ [ 'Administrator', 'Editor' ]
        
      end
    end

  end
end
