class Site
  include Mongoid::Document
  include Mongoid::Spacial::Document

  attr_accessor :latitude
  attr_accessor :longitude

  field :title, type: String
  field :description, type: String
  field :location, spacial: true

  spacial_index :location

  validates :title, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  set_callback(:save, :before) do |document|
    document.location = { lng: longitude, lat: latitude }
  end

  set_callback(:initialize, :after) do |document|
    if document.location and document.latitude.blank? and document.longitude.blank?
      document.latitude = document.location[ :lat ]
      document.longitude = document.location[ :lng ]
    end
  end
end
