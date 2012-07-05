class OrganizationsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /organizations
  def index
    respond_with @organizations
  end

  # GET /organizations/1
  def show
    respond_with @organization
  end

  # GET /organizations/new
  def new
    respond_with @organization
  end

  # GET /organizations/1/edit
  def edit
    respond_with @organization
  end

  # POST /organizations
  def create
    # Make the current user an admin
    @organization.organization_users.build( user: current_user, roles: [ 'Administrator' ] )

    if @organization.save
      flash[ :notice ] = 'Organization was successfully created.'
    end

    respond_with @organization
  end

  # PUT /organizations/1
  def update
    if @organization.update_attributes( params[ :organization ] )
      flash[ :notice ] = 'Organization was successfully updated.'
    end

    respond_with @organization
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
    respond_with @organization
  end
end
