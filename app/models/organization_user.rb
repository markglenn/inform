class OrganizationUser
  include Mongoid::Document

  embedded_in :organization

  belongs_to :user
  field :roles, :type => Array

  validates :user, presence: true
end
