class ApplicationController < ActionController::Base
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

 private

 def authenticate_user_from_token!
   authenticate_with_http_token do |token, options|
     user_email = options[:email].presence
     user = user_email && User.find_by_email(user_email)

     if user && Devise.secure_compare(user.authentication_token, token)
       puts 'usr to sign in' + user.to_s
       sign_in user, store: false
       puts 'Current user ' + current_user.to_s
     end
   end
 end
end
