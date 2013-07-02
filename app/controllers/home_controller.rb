class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def login  
    
    if current_user.contacts.empty?
      redirect_to contacts_path
      
    elsif current_user.facebook_id.blank?
      # If current_user has not linked facebook
      render action: 'facebook_connect' 
    
    else
      redirect_to events_path
    end
    
  end
  
  def facebook_connect
  end
  
end
