# -*- coding: utf-8 -*-
class TimeSlot < HashModel
  
  attr_accessor :place_area
  
  def event
    place_area.event
  end
  
  def sessions
    @sessions ||= begin
      a = []
      @raw_data.sessions.each do |s|
        session = Session.new s
        session.time_slot = self
        a << session
      end
      a
    end
  end
  
  def start_at
    @start_at ||= Time.iso8601(@raw_data.start_at)
  end
  
  def end_at
    @end_at ||= Time.iso8601(@raw_data.end_at)
  end
  
  def start_at_text
    sprintf("%d:%02d", start_at.hour, start_at.min)
  end
  
  def time_range_text
    s = start_at.string_with_style(:medium)
    s + sprintf(" %d:%02d - %d:%02d", start_at.hour, start_at.min, end_at.hour, end_at.min)
  end
  
end
