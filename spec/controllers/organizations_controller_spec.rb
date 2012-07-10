require 'spec_helper'

describe OrganizationsController do
  include Devise::TestHelpers

  let( :user ){ FactoryGirl.create( :user ) }
  let( :organization_user ){ FactoryGirl.build( :organization_user, user: user, roles: [ 'Administrator' ] ) }

  before :each do
    sign_in user
  end

  # This should return the minimal set of attributes required to create a valid
  # Organization. As you add validations to Organization, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for( :organization, organization_users: [ organization_user ] )
  end
  
  describe "GET index" do
    it "assigns all organizations as @organizations" do
      organization = Organization.create! valid_attributes
      get :index, {}
      assigns(:organizations).to_a.should =~ [organization]
    end

    it 'should only get organizations for user' do
      organization = FactoryGirl.create( :organization )
      get :index, {}
      assigns( :organizations).should be_empty
    end

    it 'should get organizations that contain user in non-first position' do
      organization = FactoryGirl.build( :organization )
      organization.organization_users << OrganizationUser.new( user: user )
      organization.save

      get :index, {}
      assigns( :organizations ).to_a.should =~ [organization]
    end
  end

  describe "GET show" do
    it "assigns the requested organization as @organization" do
      organization = Organization.create! valid_attributes
      get :show, {:id => organization.to_param}
      assigns(:organization).should eq(organization)
    end

    it 'should only get organization that user is a part of' do
      organization = FactoryGirl.create( :organization )

      lambda {
        get :show, id: organization.to_param
      }.should raise_error( CanCan::AccessDenied )
    end
  end

  describe "GET new" do
    it "assigns a new organization as @organization" do
      get :new, {}
      assigns(:organization).should be_a_new(Organization)
    end
  end

  describe "GET edit" do
    it "assigns the requested organization as @organization" do
      organization = Organization.create! valid_attributes
      get :edit, {:id => organization.to_param}
      assigns(:organization).should eq(organization)
    end

    it 'should raise 403 if not user of organization' do
      organization = FactoryGirl.create( :organization )
      lambda {
        get :edit, {:id => organization.to_param}
      }.should raise_error( CanCan::AccessDenied )
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Organization" do
        expect {
          post :create, {:organization => valid_attributes}
        }.to change(Organization, :count).by(1)
      end

      it "assigns a newly created organization as @organization" do
        post :create, {:organization => valid_attributes}
        assigns(:organization).should be_a(Organization)
        assigns(:organization).should be_persisted
      end

      it "redirects to the created organization" do
        post :create, {:organization => valid_attributes}
        response.should redirect_to(Organization.last)
      end

      it 'assigns current user as admin to organization' do
        post :create, { organization: valid_attributes }
        assigns( :organization ).roles_for_user( user ).should =~ [ 'Administrator' ]
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved organization as @organization" do
        # Trigger the behavior that occurs when invalid params are submitted
        Organization.any_instance.stub(:save).and_return(false)
        post :create, {:organization => {}}
        assigns(:organization).should be_a_new(Organization)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        organization = valid_attributes
        organization[ :name ] = nil
        post :create, {:organization => organization}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested organization" do
        organization = Organization.create! valid_attributes
        # Assuming there are no other organizations in the database, this
        # specifies that the Organization created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Organization.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => organization.to_param, :organization => {'these' => 'params'}}
      end

      it "assigns the requested organization as @organization" do
        organization = Organization.create! valid_attributes
        put :update, {:id => organization.to_param, :organization => { name: 'New Name' } }
        assigns(:organization).should eq(organization)
      end

      it "redirects to the organization" do
        organization = Organization.create! valid_attributes
        put :update, {:id => organization.to_param, :organization => { name: 'New Name' } }
        response.should redirect_to(organization)
      end
    end

    describe "with invalid params" do
      it "assigns the organization as @organization" do
        organization = Organization.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Organization.any_instance.stub(:save).and_return(false)
        put :update, {:id => organization.to_param, :organization => {}}
        assigns(:organization).should eq(organization)
      end

      it "re-renders the 'edit' template" do
        organization = Organization.create! valid_attributes

        # Trigger the behavior that occurs when invalid params are submitted
        put :update, {:id => organization.to_param, organization: { name: nil }}
        response.should render_template("edit")
      end
    end

    it 'should raise 403 when not a part of organization' do
      organization = FactoryGirl.create( :organization )
      expect {
        put :update, { id: organization.to_param, organization: { }}
      }.should raise_error( CanCan::AccessDenied )
    end

    it 'should raise 403 when not an admin for organization' do
      organization = FactoryGirl.create( :organization )
      organization.organization_users.create( user: user, roles: [] )
      organization.save!

      expect {
        put :update, { id: organization.to_param, organization: { }}
      }.should raise_error( CanCan::AccessDenied )
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested organization" do
      organization = Organization.create! valid_attributes
      expect {
        delete :destroy, {:id => organization.to_param}
      }.to change(Organization, :count).by(-1)
    end

    it "redirects to the organizations list" do
      organization = Organization.create! valid_attributes
      delete :destroy, {:id => organization.to_param}
      response.should redirect_to(organizations_url)
    end

    it 'should raise 403 when user not a part of organization' do
      organization = FactoryGirl.create( :organization )
      expect {
        delete :destroy, {:id => organization.to_param}
      }.should raise_error( CanCan::AccessDenied )

    end
  end

end
