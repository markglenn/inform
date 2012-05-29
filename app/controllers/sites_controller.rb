class SitesController < ApplicationController
  respond_to :html

  # GET /sites
  def index
    respond_with( @sites = Site.all )
  end

  # GET /sites/1
  def show
    respond_with( @site = Site.find(params[:id]) )
  end

  def near
    @sites = Site.where( :location.near => [[ params[ :latitude ].to_f, params[ :longitude ].to_f ], 5] )
  end

  # GET /sites/new
  def new
    @site = Site.new

    respond_with( @site )
  end

  # GET /sites/1/edit
  def edit
    respond_with( @site = Site.find(params[:id]) )
  end

  # POST /sites
  def create
    @site = Site.new(params[:site])

    if @site.save
      flash[ :notice ] = 'Site was successfully created.'
    end

    respond_with( @site )
  end

  # PUT /sites/1
  def update
    @site = Site.find(params[:id])

    if @site.update_attributes(params[:site])
      flash[ :notice ] = 'Site was successfully updated.'
    end

    respond_with( @site )
  end

  # DELETE /sites/1
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_with( @site )
  end
end