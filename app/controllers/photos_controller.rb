require 'flickraw'
require 'koala'
require 'twitter'
require 'omniauth'

class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :update, :destroy]

  def tw_upload
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "wmrQH8XDlHHb5vzJnXNXckXLD"
      config.consumer_secret     = "Ct0TCXtayylU9iToJpH1lus5QyN4tEiIhmZy6S797J1DJjo6IK"
      config.access_token        = "139442119-tvzhQazV9U7GiwxLPuP2mqItrcj7oJid4AunxOs4"
      config.access_token_secret = "8SbkrShQR1FlzjNW1MfUlgsU04AN4CpASFRegdb5pZUjD"
    end
  end

    # moze to działa
    # media = %w(/path/to/media1.png /path/to/media2.png).map { |filename| File.new(filename) }
    # client.update_with_media("I'm tweeting with @gem!", media)

    #  photos = []
    #  photos.push(:media_data => params[:file])
    # media_ids = photos.map do |filename|
    #   Thread.new do
    #     client.upload(File.new(filename))
    #   end
    # end.map(&:value)
    #
    # client.update("Tweet text", :media_ids => media_ids.join(','))

def auth_facebook_callback
  # user_info = omniauth_auth['info']
  # @user = User.find_or_create_by(name: user_info['nickname'])
  # @user.generate_token_fb
  # @user.save!
  # puts env['omniauth.error'].inspect

  oauth_credentials = omniauth_auth['credentials']
  token = oauth_credentials['token']
  puts 'token token ' + token
  # zapisac token dla osoby i później utworzyc tam nowy graph

    @@graph = Koala::Facebook::API.new(token)
    redirect_to 'http://127.0.0.1:4200/?code=' + token.to_s
  end
  # def fb_token
  #   @oauth = Koala::Facebook::OAuth.new('1572255896381258',
  #     '785b6564e5404a607e71a12d2a90e625', 'http://127.0.0.1:3000/fb_token')
  #
  #   token = @oauth.get_access_token(params[:code])
  #   puts 'token token ' + token
  #   @@graph = Koala::Facebook::API.new(token)
  # end

  def auth_token
    request.env["HTTP_AUTHORIZATION"]
  end

  def authenticated
    if auth_token and
        User.find_by(token: auth_token)
      true
    else
      puts("Not authorized\n""Not authorized\n""Not authorized\n")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def omniauth_auth
    request.env['omniauth.auth']
  end

  def auth_twitter_callback
    user_info = omniauth_auth['info']
    @user = User.find_or_create_by(name: user_info['nickname'])
    @user.generate_token
    @user.save!
    puts env['omniauth.error'].inspect
    redirect_to 'http://127.0.0.1:4200/?code=' + @user.token.to_s
  end


  API_KEY="fcd5d8dfee245259c28a4393c85231d4"
  SHARED_SECRET="1e0a0da30d41d4bd"

  FlickRaw.api_key=API_KEY
  FlickRaw.shared_secret=SHARED_SECRET

  def auth_flickr_callback
    user_info = omniauth_auth['info']
    @user = User.find_or_create_by(name: user_info['nickname'])
    @user.generate_token_flickr
    @user.save!
    redirect_to 'http://127.0.0.1:4200/?code=' + @user.token_flickr.to_s

    oauth_credentials = omniauth_auth['credentials']
    flickr = FlickRaw::Flickr.new
    oauth_token = oauth_credentials['token']
    oauth_token_secret = oauth_credentials['secret']

    flickr.access_token = oauth_token
    flickr.access_secret = oauth_token_secret

    begin
      login = flickr.test.login
      puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
    rescue FlickRaw::FailedResponse => e
      puts "Authentication failed : #{e.msg}"
    end
  end

  def auth_faliure
    redirect_to '/'
  end

  def logout
    authenticated
    user = User.find_by(token: auth_token)
    user.token = nil
    user.save!
    redirect_to '/'
  end

  def users_me
    authenticated
    u = User.find_by(:token => auth_token)
    {
      "user" => u
    }.to_json
  end


  def ide
    File.read(File.join('public/dist', 'index.html'))
  end

# Users should hit this method to get the link which sends them to flickr
# def auth
#   callback_url = 'http://localhost:3000/auth/flickr/callback'
#   flickr = FlickRaw::Flickr.new
#   @token = flickr.get_request_token(oauth_callback: URI.escape(callback_url))
#
#   @auth_url = flickr.get_authorize_url(@token['oauth_token'], perms: 'write')
#   render json: @auth_url
# end
#
# # Your users browser will be redirected here from Flickr (see @callback_url above)
# def auth_flickr_callback
#   flickr = FlickRaw::Flickr.new
#   puts 'aaaa' + @token.to_s
#   request_token = @token
#   oauth_token = params[:oauth_token]
#   oauth_verifier = params[:oauth_verifier]
#
#   raw_token = flickr.get_access_token(request_token['oauth_token'], request_token['oauth_token_secret'], oauth_verifier)
#
#   oauth_token = raw_token["oauth_token"]
#   oauth_token_secret = raw_token["oauth_token_secret"]
#
#   flickr.access_token = oauth_token
#   flickr.access_secret = oauth_token_secret
#   redirect_to 'http://127.0.0.1:4200/?code=' + oauth_token
# end

  def upload_fb
    @@graph.put_picture(params[:file], params[:content_type], {:message => "Działa :D"}, "me")
    # @graph.put_picture(params[:file], {:message => "Message"}, my_album_id)
    @flickr.upload_photo params[:file], :title => params[:filename], :description => 'This is the description'
  end

  def upload_fl
    @flickr.upload_photo params[:file], :title => params[:filename], :description => 'This is the description'
  end

  # def search
  #   args = {}
  #
  #   # requires a limiting factor, so let's give it one
  #   args[:text] = params[:search_text]
  #   args[:min_taken_date] = '2015-01-01 09:00:00'
  #   args[:max_taken_date] = '2015-01-01 09:00:10'
  #   args[:accuracy] = 1 # the default is street only granularity [16], which most images aren't...
  #   discovered_pictures = flickr.photos.search args
  #
  #   discovered_pictures.each{ |p| url = FlickRaw.url p;
  #     Photo.create(name:"1", url: url, owner:'ferdek', checked: false)
  #     puts url}
  #     index
  # end

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
