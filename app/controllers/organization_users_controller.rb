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
    @organization_user.attributes = params[ :organization_user ]

    if @organization.save
      flash[ :notice ] = 'Organization was successfully updated.'
      redirect_to @organization
    else
      render action: 'edit'
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

    # Find all admins
    users = @organization.organization_users.select{|ou| ou.roles.include? 'Administrator' }

    if users.length == 1 and users.first.to_param == params[ :id ] 
      # Trying to delete the only admin
      @organization.errors.add( :base, 'Cannot remove last admin' )
    else
      @organization.organization_users.where( _id: params[ :id ] ).destroy_all
    end

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
