require 'spec_helper'

describe OrganizationUsersController do
  include Devise::TestHelpers

  before :each do
    @current_user = FactoryGirl.create( :user )
    sign_in @current_user
  end

  describe 'GET index' do
    before :each do
      @organization = FactoryGirl.create( :organization, :with_user )
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
      assigns( :organization_user ).should == @ou
    end

    it 'should set organization_user_view_model' do
      get :edit, organization_id: @organization.to_param, id: @ou.to_param
      assigns( :organization_user ).email.should == @user.email
    end
  end

  describe 'PUT update' do
    describe 'with valid attributes' do

      before :each do
        @organization = FactoryGirl.create( :organization, :with_user )
        @organization_user = @organization.organization_users.first
      end

      it 'updates the requested organization' do
        new_user = FactoryGirl.create( :user )
        put :update, { organization_id: @organization.to_param, id: @organization_user.to_param, organization_user: { email: new_user.email } }

        @organization.reload
        @organization.organization_users.first.user.should == new_user
      end

      it 'should return error when user not found' do
        put :update, { organization_id: @organization.to_param, id: @organization_user.to_param, organization_user: { email: 'bad-email@example.com' } }
        assigns( :organization_user ).errors.should_not be_empty
      end

      it 'should update roles for user' do
        user = @organization_user.user

        put :update, { 
          organization_id: @organization.to_param, 
          id: @organization_user.to_param, 
          organization_user: { email: user.email, roles: [ 'Administrator', 'Editor' ] }
        }

        @organization.reload

        @organization.organization_users.first.roles.should =~ [ 'Administrator', 'Editor' ]
        
      end
    end

  end

  describe 'GET new' do
    it 'should assign organization' do
      organization = FactoryGirl.create( :organization )
      get :new, organization_id: organization.to_param

      assigns( :organization ).should == organization
    end

    it 'should assign new organization user' do
      organization = FactoryGirl.create( :organization )
      get :new, organization_id: organization.to_param

      assigns( :organization_user ).should be_new_record
    end
  end

  describe "POST create" do
    before :each do
      @organization = FactoryGirl.create( :organization )
      @user = FactoryGirl.create( :user )
      @valid_attributes = FactoryGirl.attributes_for( :organization_user, user_id: @user._id )
    end

    describe "with valid params" do
      it "creates a new Organization" do
        post :create, { organization_id: @organization.to_param, organization_user: @valid_attributes }

        @organization.reload
        @organization.organization_users.should_not be_empty
      end

      it "assigns a the organization as @organization" do
        post :create, organization_id: @organization.to_param, organization_user: @valid_attributes
        assigns(:organization).should be_a(Organization)
        assigns(:organization).should be_persisted
      end

      it "redirects to the created organization user" do
        post :create, organization_id: @organization.to_param, organization_user: @valid_attributes
        response.should redirect_to([@organization, @organization.organization_users.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved organization user as @organization_user" do
        # Trigger the behavior that occurs when invalid params are submitted
        Organization.any_instance.stub(:save).and_return(false)
        post :create, organization_id: @organization.to_param, organization_user: {}
        assigns(:organization_user).should be_a_new(OrganizationUser)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        organization_user = @valid_attributes
        organization_user[ :user ] = nil
        post :create, organization_id: @organization.to_param, organization_user: organization_user
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested organization" do
      organization = FactoryGirl.create( :organization, :with_user )
      delete :destroy, organization_id: organization.to_param, id: organization.organization_users.first.to_param

      organization.reload
      organization.organization_users.should be_blank
    end

    it "redirects to the organization show page" do
      organization = FactoryGirl.create( :organization, :with_user )
      delete :destroy, organization_id: organization.to_param, id: organization.organization_users.first.to_param
      response.should redirect_to(organization)
    end

  end

end
