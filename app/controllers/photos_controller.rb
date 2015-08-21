require 'flickraw'
require 'koala'
require 'twitter'
require 'omniauth'

class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :update, :destroy]

  FlickRaw.api_key=ENV['FLICKR_KEY']
  FlickRaw.shared_secret=ENV['FLICKR_SECRET']

  def upload
    #===FACEBOOK=====
    # if current_user.authorizations.pluck('facebook').include?('facebook')
      token = current_user.authorizations.find_by(provider: 'facebook').token
      graph = Koala::Facebook::API.new(token)
      graph.put_picture(params[:file], params[:content_type], {:message => "Działa :D"}, "me")
      # @graph.put_picture(params[:file], {:message => "Message"}, my_album_id)
    # end
    #====FLICKR ====
    @flickr = FlickRaw::Flickr.new

    @flickr.access_token = current_user.authorizations.find_by(provider: 'flickr').token
    @flickr.access_secret =current_user.authorizations.find_by(provider: 'flickr').secret
    @flickr.upload_photo params[:file], :title => params[:filename], :description => 'This is the description'

  end

  # GET /photos.json
  def index
    @photos = Photo.all

    render json: @photos
  end

  # GET /photos/1.json
  def show
    render json: @photo
  end

  # POST /photos.json
  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      render json: @photo, status: :created, location: @photo
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])

    if @photo.update(photo_params)
      head :no_content
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /photos/1.json
  def destroy
    @photo.destroy

    head :no_content
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:name, :url, :owner, :checked)
  end
end
