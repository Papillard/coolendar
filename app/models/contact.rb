class Contact < ActiveRecord::Base
  attr_accessible :email, :name, :picture_url, :active
  
  belongs_to :user
  
end
