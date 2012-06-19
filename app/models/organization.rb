class Organization
  include Mongoid::Document

  embeds_many :organization_users

  field :name,        type: String
  field :description, type: String

  validates :name, presence: true, uniqueness: true
  validates :description, length: { within: 0 .. 3000 }
end