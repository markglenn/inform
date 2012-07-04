class Organization
  include Mongoid::Document

  embeds_many :organization_users

  field :name,        type: String
  field :description, type: String

  validates :name, presence: true, uniqueness: true
  validates :description, length: { within: 0 .. 3000 }

  index "organization_users.user_id"
  index :name

  # Find organizations that have a user
  def self.for_user( user )
    user_id = user.is_a?( User ) ? user.id : BSON::ObjectId( user )
    where( organization_users: { '$elemMatch' => { 'user_id' => user_id } } )
  end

  # Returns roles for a particular user
  def roles_for_user( user )
    organization_users_for_user = organization_users.select{|ou| ou.user_id == user.id }
    if organization_users_for_user.any?
      organization_users_for_user.map{|ou| ou.roles}.flatten
    else
      nil
    end
  end
end
