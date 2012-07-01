class OrganizationsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  # GET /organizations
  def index
    respond_with @organizations = Organization.for_user( current_user ).all
  end

  # GET /organizations/1
  def show
    respond_with @organization = Organization.for_user( current_user ).find(params[:id])
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @organization.organization_users.build( user: current_user )

    respond_with @organization
  end

  # GET /organizations/1/edit
  def edit
    respond_with @organization = Organization.for_user( current_user ).find(params[:id])
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])

    # Make the current user an admin
    @organization.organization_users.build( user: current_user, roles: [ 'Admin' ] )

    if @organization.save
      flash[ :notice ] = 'Organization was successfully created.'
    end

    respond_with @organization
  end

  # PUT /organizations/1
  def update
    @organization = Organization.for_user( current_user ).find(params[:id])

    if @organization.update_attributes( params[ :organization ] )
      flash[ :notice ] = 'Organization was successfully updated.'
    end

    respond_with @organization
  end

  # DELETE /organizations/1
  def destroy
    @organization = Organization.for_user( current_user ).find(params[:id])
    @organization.destroy

    respond_with @organization
  end
end
