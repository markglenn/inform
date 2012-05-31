class Site
  include Gmaps4rails::ActsAsGmappable
  include Mongoid::Document
  include Mongoid::Spacial::Document

  acts_as_gmappable :process_geocoding => false

  attr_accessor :latitude
  attr_accessor :longitude

  field :title, type: String
  field :description, type: String
  field :location, spacial: true

  spacial_index :location

  validates :title, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  def gmaps4rails_title
    self.title
  end

  def gmaps4rails_infowindow
    self.title + " <a href='http://www.google.com/'>Click Me</a>".html_safe
  end

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
