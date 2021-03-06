class Site
  include Mongoid::Document

  attr_accessor :latitude
  attr_accessor :longitude

  belongs_to :organization

  field :title, type: String
  field :description, type: String
  field :location, type: Array

  index [[ :location, Mongo::GEO2D ]]

  validates :title,         presence: true
  validates :latitude,      presence: true
  validates :longitude,     presence: true
  validates :organization,  presence: true

  set_callback(:validation, :before) do |document|
    document.location = [ document.longitude.to_f, document.latitude.to_f ]
  end

  set_callback(:initialize, :after) do |document|
    if document.location and document.latitude.blank? and document.longitude.blank?
      document.longitude = document.location[ 0 ].to_f
      document.latitude = document.location[ 1 ].to_f
    end
  end
end
