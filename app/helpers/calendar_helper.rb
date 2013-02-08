module CalendarHelper
  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).coolendar
  end

  class Calendar < Struct.new(:view, :date, :callback)
    START_DAY = :monday
    HEADER = %w[mon tue wed thu fri sat sun ?]

    delegate :content_tag, to: :view
    
    def coolendar
      content_tag :div, class: "container calendar" do
          week_rows
      end
    end
    
    def header
       content_tag :div, class: "row-fluid cal-header-row" do
        HEADER.map do |day|
          content_tag :div, class: 'span1 cal-header-day muted' do
            content_tag(:p,day)
          end
        end.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :div, class: 'row-fluid' do
          content_tag :div, class: 'span10 cal-week-section' do 
             week_title(week) + header + week_days(week) 
          end
        end
      end.join.html_safe
    end
    
    def weeks
      (date.beginning_of_month.beginning_of_week(START_DAY)..date.end_of_month.end_of_week(START_DAY)).to_a.in_groups_of(7)
    end
    
    def week_title(week)
      if week.include?(Date.today)
        content_tag(:h4,"This Week", class: 'cal-week-title')
      elsif week.include?(Date.today.next_week)
        content_tag(:h4,"Next week", class: 'cal-week-title')
      elsif week.include?(Date.today.next_week.next_week)
        content_tag(:h4,"End of month", class: 'cal-week-title')
      else
        content_tag(:h4,"") 
      end
    end
    
    def week_days(someDays)
      content_tag :div, class: 'row-fluid cal-week-row' do 
        someDays.map  do |day| 
          content_tag :div, class: day_classes(day) do
            day_title(day) + day_inner(day)
          end
        end.join.html_safe
      end
    end
    
    def day_title(day)
      content_tag :div, class: 'row-fluid cal-day-title' do
        content_tag(:h8, day.strftime("%d"))
      end
    end

    def day_inner(day)
      content_tag :div, class: 'row-fluid' do 
        content_tag :div, view.capture(day, &callback), class: 'span12'
      end
    end
         
    def day_classes(day)
      classes = ['span1 cal-day-section']
      classes << "today" if day == Date.today
      classes << "notmonth" if day.month != date.month || day < Date.today 
      classes.empty? ? nil : classes.join(" ")
    end
  end
end