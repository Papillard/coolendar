OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do  
  
  if Rails.env.production?

  else
    provider :facebook, '475199592541938', '25b9a11fb2cd0bb467b070c6ab02f3f4',
    {:scope => 'user_about_me,offline_access,email'}
   
    provider :google_oauth2, '230636480839.apps.googleusercontent.com', 'vX3KNICpFdTx1I2e_RkBP9ZH', {access_type: 'online', approval_prompt: ''}
    
    #provider :google_oauth2, '230636480839.apps.googleusercontent.com', 'vX3KNICpFdTx1I2e_RkBP9ZH',{
    #access_type: 'offline',
    #scope: 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
    #redirect_url:'http://localhost:3000/auth/google_oauth2/callback'}  
    
  end
  
end

