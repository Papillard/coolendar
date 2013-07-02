class Authentication < ActiveRecord::Base
  attr_accessible :provider, :token, :refresh_token, :token_expires_time
  
  validates :provider, :token, :token_expires_time, presence: true 
  validate :token, uniqueness: true
  
  belongs_to :user
  
  private
  
  def token_expired?
    if(self.token_expires_time < Time.now.to_i)
      return true
    else
      return false
    end
  end

  def refresh_google_token
    client_id = Kaala::Application::GOOGLE_CLIENT
    client_secret = Kaala::Application::GOOGLE_SECRET

    if Rails.env.production?
      client_id = '646174145614.apps.googleusercontent.com'
      client_secret = 'm-fGutADl9Ou3zCt-RBdF2kC'
    end

    param = {
          :client_id => client_id,
          :client_secret => client_secret,
          :refresh_token => self.refresh_token,
          :grant_type => 'refresh_token'
        }
    uri = URI.parse("https://accounts.google.com/o/oauth2/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = param.to_query
    result = http.request(request).body
    response = JSON.load(result)
    self.token = response["access_token"]
    self.token_expires_time = response["expires_in"].to_i + Time.now.to_i
    self.save
  end
  
end
  