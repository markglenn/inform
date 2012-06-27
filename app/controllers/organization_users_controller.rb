class OrganizationUsersController < ApplicationController
  def index
    @organization = Organization.find( params[ :organization_id ] )
  end

  def show
    @organization = Organization.for_user( params[ :id ] ).find( params[ :organization_id ] )
    @organization_user = @organization.organization_users.select{|ou| ou.user_id.to_s == params[ :id ]}.first
  end
end
