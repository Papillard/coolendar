module EventsHelper
  
  def custom_date(aDate)
    aDate.strftime("%^a %d %^B %y")
  end  
  def custom_time(aDate)
    aDate.strftime("%Hh%M")
  end
  
  def group_events(someEvents)
    # Grouping by time_section
    events_grouped_by_time_section = someEvents.group_by {|e| e.time_section }   
    events_grouped = {}
    # Grouping by days
    events_grouped_by_time_section.each do |ts,events|
      events_grouped[ts] = events_grouped_by_time_section[ts].group_by{|e| e.date.to_date}
    end
    return events_grouped
  end

end
