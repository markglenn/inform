require 'role_constants'

class OrganizationUser
  include Mongoid::Document
  include RoleConstants

  after_initialize lambda { @email = self.user.email if self.user }
  before_validation :update_user_by_email
  before_validation :cleanup_roles

  embedded_in :organization

  attr_accessor :email

  belongs_to :user
  field :roles, :type => Array

  validates :user, presence: true

  private

  def update_user_by_email
    unless self.changed_attributes.has_key? 'user_id' or @email.blank?
      self.user = User.where( email: @email ).first

      if self.user.nil?
        self.errors
      end
    end
  end

  def cleanup_roles
    self.roles = self.roles.reject{ |r| r.blank? } if self.roles
  end
end
