class AuthenticationsController < ApplicationController
 
  # POST /authentications
  # POST /authentications.json
  def create
    omniauth = request.env["omniauth.auth"]
    
    # We look for a user having the call back provider_id
    case omniauth['provider']
      when 'facebook'
        user = User.find_by_facebook_id(omniauth['uid'])
      when 'google_oauth2'
        user = User.find_by_google_id(omniauth['uid'])
    end
    
    # We find this user 
    if user
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user)
      
    # This user is logged in
    elsif current_user
      current_user.apply_omniauth(omniauth)
      sign_in_and_redirect(:user, current_user)
      
    # First connection
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth
        redirect_to new_user_registration_url
      end
    end
  end
end
        
        
      
      
      
      
        
      
    
      
    
  