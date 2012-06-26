class Organization
  include Mongoid::Document

  embeds_many :organization_users

  field :name,        type: String
  field :description, type: String

  validates :name, presence: true, uniqueness: true
  validates :description, length: { within: 0 .. 3000 }

  index "organization_users.user_id"
  index :name

  def self.for_user( user )
    where( organization_users: { '$elemMatch' => { user_id: user.id } } )
  end
end
