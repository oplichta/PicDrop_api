require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe 'Facebook login' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
      user_sign_in = User.create!(email: 'joe@bloggs.com', password: 'my_secret')
      sign_in user_sign_in
      get :facebook
    end

    it 'should add facebook authentication to user' do
      user = User.find_by(email: 'joe@bloggs.com')
      fb_authentication = user.authorizations.find_by(provider: 'facebook')
      expect(user).not_to be_nil
      expect(fb_authentication).not_to be_nil
      expect(fb_authentication.uid).to eq('12345')
    end

    it 'should redirect_to ember' do
      expect(response).to redirect_to 'http://127.0.0.1:4200/?auth_code=' + request.env['omniauth.auth']['credentials']['token']
    end
  end

  describe 'Flickr login' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:flickr]
      user_sign_in = User.create!(email: 'joe@bloggs.com', password: 'my_secret')
      sign_in user_sign_in
      get :flickr
    end

    it 'should add flickr authentication to user' do
      user = User.find_by(email: 'joe@bloggs.com')
      fr_authentication = user.authorizations.find_by(provider: 'flickr')
      expect(user).not_to be_nil
      expect(fr_authentication).not_to be_nil
      expect(fr_authentication.uid).to eq('12345')
    end

    it 'should redirect_to ember' do
      expect(response).to redirect_to 'http://127.0.0.1:4200/?auth_code=' + request.env['omniauth.auth']['credentials']['token']
    end
  end
end
