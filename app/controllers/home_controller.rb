class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def login  
    if current_user.google_id.blank?
      render action: 'google_connect'
    else
      google_auth.refresh_google_token if google_auth.token_expired?
    end
  end
  
  def google_connect
  end
  
end
