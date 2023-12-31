class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :set_account
=begin 
    def google_oauth2 
    # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env["omniauth.auth"])
        if @user.persisted?
            sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
            set_flash_message(:notice, :success, :kind => "Google") if
            is_navigational_format?
        else
            session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
            redirect_to new_user_registration_url
        end
    end
    
    def failure
        redirect_to root_path
    end
=end
    def google_oauth2
     # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env['omniauth.auth'])

        if @user.persisted?
          flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
          sign_in_and_redirect @user, event: :authentication
        else
          session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
          redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
        end
    end
    def failure
        redirect_to root_path
    end
private

  def set_account
    @user = User.from_omniauth(request.env['omniauth.auth'])
  end
end