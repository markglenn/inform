class OrganizationUsersController < ApplicationController
  respond_to :html

  before_filter :find_organization_user, only: [ :edit, :update ]

  def index
    @organization = Organization.find( params[ :organization_id ] )
  end

  def new
    @organization = Organization.find( params[ :organization_id ] )
    @organization_user = @organization.organization_users.build
  end

  def edit
    respond_with @organization_user
  end

  def update
    if @organization_user.update_attributes( params[ :organization_user ] )
      flash[ :notice ] = 'Organization was successfully updated.'
      redirect_to @organization
    else
      respond_with @organization_user
    end
  end

  def create
    @organization = Organization.find( params[ :organization_id ] )

    @organization_user = @organization.organization_users.build( params[ :organization_user ] )

    if @organization.save
      flash[ :notice ] = 'Organization user was successfully created.'
    end

    respond_with @organization
  end

  # DELETE /organizations/1
  def destroy
    @organization = Organization.find(params[:organization_id])
    @organization.organization_users.where( _id: params[ :id ] ).destroy_all

    respond_with @organization
  end

  private 
  
  def find_organization_user
    @organization = Organization.where( organization_users: { 
      '$elemMatch' => { _id: BSON::ObjectId( params[ :id ] ) }
    } ).find( params[ :organization_id ] )

    @organization_user = @organization.organization_users.find( params[ :id ] )
  end
end
