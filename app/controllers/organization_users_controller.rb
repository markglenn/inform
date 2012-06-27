class OrganizationUsersController < ApplicationController
  respond_to :html

  def index
    @organization = Organization.find( params[ :organization_id ] )
  end

  def edit
    organization_user_id = BSON::ObjectId( params[ :id ] )
    @organization = Organization.where( organization_users: { 
      '$elemMatch' => { '_id' => organization_user_id }
    } ).find( params[ :organization_id ] )

    respond_with @organization_user = @organization.organization_users.select{|ou| ou.id == organization_user_id}.first
  end

  def update
    organization_user_id = BSON::ObjectId( params[ :id ] )
    user = User.where( email: params[ :email ] ).first

    @organization = Organization.where( organization_users: { 
      '$elemMatch' => { '_id' => organization_user_id }
    } ).find( params[ :organization_id ] )

    @organization_user = @organization.organization_users.select{|ou| ou.id == organization_user_id}.first

    if user
      if @organization_user.update_attributes( user_id: user.id, roles: params[ :roles ] )
        flash[ :notice ] = 'Organization was successfully updated.'
      end

      redirect_to @organization
    else
      @organization_user.errors[ :base ] << 'User not found'
      respond_with @organization_user
    end

  end
end
