class OrganizationsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  # GET /organizations
  def index
    respond_with @organizations = Organization.all
  end

  # GET /organizations/1
  def show
    respond_with @organization = Organization.find(params[:id])
  end

  # GET /organizations/new
  def new
    respond_with @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    respond_with @organization = Organization.find(params[:id])
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])

    if @organization.save
      flash[ :notice ] = 'Organization was successfully created.'
    end

    respond_with @organization
  end

  # PUT /organizations/1
  def update
    @organization = Organization.find(params[:id])

    if @organization.update_attributes( params[ :organization ] )
      flash[ :notice ] = 'Organization was successfully updated.'
    end

    respond_with @organization
  end

  # DELETE /organizations/1
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_with @organization
  end
end