class User < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable #, :confirmable, :rememberable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :user_name, :picture_url, :facebook_id, :google_id

  validates :email, :password, :password_confirmation, presence: true #,:remember_me
  validates :email, uniqueness: true  

  has_many :authentications , :dependent => :destroy
  has_many :contacts, :dependent => :destroy

  #------------------------------------------Authentication--------------------------------------------------
  #---------------------------General----------------------------
  def apply_omniauth(omniauth)
      case omniauth['provider']
      when 'facebook'
        self.apply_facebook(omniauth)
      when 'google_oauth2'
        self.apply_google(omniauth)
      end
  end
  
  def password_required?
    (self.authentications.empty? || self.password.blank?) && super
  end
  
  #---------------------------Facebook---------------------------
  def apply_facebook(omniauth)
    if (extra = omniauth['extra']['raw_info'] rescue false)
      self.update_attribute(:facebook_id, omniauth['uid']) 
      self.update_attribute(:user_name, omniauth['extra']['raw_info']['username']) if self.user_name.blank? 
      self.update_attribute(:picture_url, 'https://graph.facebook.com/'+ omniauth['uid'] +'/picture')
      
      #Will be set from google
      #self.email = omniauth['extra']['raw_info']['email'] if self.email.blank? # no email over-ride if user already authenticated through google
    end 
      
    
    self.authentications.create(
      :provider => omniauth['provider'],
      :token => (omniauth['credentials']['token'] rescue nil),
      :refresh_token => "",
      :token_expires_time => (omniauth['credentials']['expires_at'].to_i rescue nil)
    )
  end

  #---------------------------Google-----------------------------  
  def apply_google(omniauth)
    
    if (extra = omniauth['info'] rescue false)
      self.email = omniauth['info']['email'] if self.email.blank?
      self.user_name = omniauth['info']['name'] if self.user_name.blank?
      self.google_id = omniauth['uid']
      
      #Will be set from facebook
      #self.picture_url = omniauth['info']['image'] if self.picture_url.blank?
    end
    

    self.authentications.build(
      :provider => omniauth['provider'],
      :token => (omniauth['credentials']['token'] rescue nil),
      :refresh_token => (omniauth['credentials']['refresh_token'] rescue nil),
      :token_expires_time => (omniauth['credentials']['expires_at'].to_i rescue nil)
    )
  end

  #------------------------------------------Get Contacts--------------------------------------------------

   def get_google_contacts()

     google_auth = self.authentications.find_by_provider("google_oauth2") 

     if(google_auth != nil)  

       token = google_auth.token

       uri = URI.parse("https://www.google.com/m8/feeds/contacts/default/full?access_token=#{token}&alt=json&max-results=100")

       http = Net::HTTP.new(uri.host, uri.port)
       http.use_ssl = true
       http.verify_mode = OpenSSL::SSL::VERIFY_NONE
       request = Net::HTTP::Get.new(uri.request_uri)
       result = http.request(request).body
       contacts = ActiveSupport::JSON.decode(result)
       
       contacts['feed']['entry'].each_with_index do |contact,index|
         if !contact['title']['$t'].empty?
                      
           if contact['link'][1]['type'] == 'application/atom+xml'
             pics = "default_pic.svg"
           else 
             pics = contact['link'][1]['href']+"?access_token=#{google_auth.token}"
           end  
           self.contacts.create(name: contact['title']['$t'], email: contact['gd$email'][0]['address'], picture_url: pics, active: true)
         end
       end         
     end
   end 
   
end
