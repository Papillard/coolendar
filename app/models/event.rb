class Event < ActiveRecord::Base
  attr_accessible :date, :description, :flexible, :location, :time_section
  
  TIME_SECTION = %w( Today Tomorrow ThisWeek NextWeek ThisMonth M2 M3 M4 M5 M6 After )

  validates :date, :description, presence: true
  validates_length_of :description, maximum: 140
  
  #validates :date, :description, :time_section, presence: true
  #validates :time_section, inclusion: TIME_SECTION
  
  
end

