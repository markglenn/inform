class Site
  include Mongoid::Document
  include Mongoid::Spacial::Document

  attr_accessor :latitude
  attr_accessor :longitude

  field :title, type: String
  field :description, type: String
  field :location, spacial: true

  validates :title, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  set_callback(:save, :before) do |document|
    self.location = { lng: longitude, lat: latitude }
  end

  set_callback(:initialize, :after) do |document|
    if self.location and latitude.blank? and longitude.blank?
      self.latitude = self.location[ :lat ]
      self.longitude = self.location[ :lng ]
    end
  end
end
