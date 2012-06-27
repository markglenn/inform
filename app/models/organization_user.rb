require 'role_constants'

class OrganizationUser
  include Mongoid::Document
  include RoleConstants

  embedded_in :organization

  belongs_to :user
  field :roles, :type => Array

  validates :user, presence: true
end
