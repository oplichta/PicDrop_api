class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]
  skip_before_filter :authenticate_user!
	def all
		p env["omniauth.auth"]
		user = User.from_omniauth(env["omniauth.auth"], current_user)
		if user.persisted?
			puts "You are in..!!! Go to edit profile to see the status for the accounts"
			sign_in(user)
      redirect_to 'http://127.0.0.1:4200/?auth_code='+request.env['omniauth.auth']['credentials']['token']
		else
			session["devise.user_attributes"] = user.attributes
			redirect_to new_user_registration_url
		end
	end

	  def failure
      puts "Auth failure"
      super
   end


	alias_method :facebook, :all
	alias_method :twitter, :all
	alias_method :linkedin, :all
	alias_method :github, :all
	alias_method :passthru, :all
	alias_method :google_oauth2, :all
	alias_method :flickr, :all

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
