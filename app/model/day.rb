# -*- coding: utf-8 -*-
class Day < HashModel

  def date
    @date ||= date_from_yyyy_mm_dd @raw_data.date
  end
  
  def events
    @events ||= @raw_data.events.map {|e| Event.new e.event }
  end
  
  def rooms
    @rooms ||= begin
      a = []
      self.events.each do |e|
        r = e.room
        a << r unless a.include? r
      end
      a.to_object
    end
  end
  
  def timespans_dict_for_room room
    h = {}
    events.each do |e|
      if e.room == room
        h[e.timespan] ||= []
        h[e.timespan] << e
      end
    end
    h.to_object
  end
  
  def sorted_rooms
    
  end
        

end
