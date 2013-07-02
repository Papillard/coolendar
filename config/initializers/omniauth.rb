OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do  
  
  if Rails.env.production?
    provider :facebook, '436226379788184', '70622a84dfff2cc5848bfce5d9e939f8',
    {:scope => 'user_about_me,offline_access,email'}
       
    provider :google_oauth2, '149937658688.apps.googleusercontent.com', 'Frr4M60r5xjbBSnHEWLt5Gjl',{
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.profile https://www.google.com/m8/feeds https://www.googleapis.com/auth/userinfo.email',
    redirect_uri:'http://coolendar.herokuapp.com/auth/google_oauth2/callback'}

  else
    provider :facebook, '475199592541938', '25b9a11fb2cd0bb467b070c6ab02f3f4',
    {:scope => 'user_about_me,offline_access,email'}
       
    provider :google_oauth2, '675279415901.apps.googleusercontent.com', 'aD14ILlgyl1MfbYj7ofX1TS7',{
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.profile https://www.google.com/m8/feeds https://www.googleapis.com/auth/userinfo.email',
    redirect_uri:'http://localhost:3000/auth/google_oauth2'}  
    
  end
  
end

