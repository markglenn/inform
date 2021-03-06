class SitesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, except: [ :index, :show, :near ]
  load_and_authorize_resource except: [ :near ]

  # GET /sites
  def index
    respond_with @sites
  end

  # GET /sites/1
  def show
    respond_with @site
  end

  # GET /sites/near/:latitude/:longitude/:accuracy
  def near
    location = [ params[ :longitude ].to_f, params[ :latitude ].to_f ]

    # Meters to degrees: ( distance in meters ) / 1000 / 111.2
    distance = [ params[ :accuracy ].to_f, 1600 ].min.fdiv( 1000.0 ).fdiv( 111.12 )

    @sites = Site.where( :location => { '$nearSphere' => location, '$maxDistance' => distance } )

    if @sites.count == 1
      redirect_to @sites.first
    else
      render action: :index
    end
  end

  # GET /sites/new
  def new
    respond_with @site
  end

  # GET /sites/1/edit
  def edit
    respond_with @site
  end

  # POST /sites
  def create
    if @site.save
      flash[ :notice ] = 'Site was successfully created.'
    end

    respond_with @site
  end

  # PUT /sites/1
  def update
    if @site.update_attributes(params[:site])
      flash[ :notice ] = 'Site was successfully updated.'
    end

    respond_with @site
  end

  # DELETE /sites/1
  def destroy
    @site.destroy

    respond_with @site
  end

  #rescue_from CanCan::AccessDenied do |exception|
  #  flash[:error] = exception.message
  #  redirect_to new_user_session_path
  #end
end
