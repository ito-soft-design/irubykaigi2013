# -*- coding: utf-8 -*-
class PlaceArea < HashModel

  attr_accessor :place
  
  def event
    place.event
  end
  
  def time_slots
    @time_slots ||= begin
      a = []
      @raw_data.time_slots.each do |t|
        slot = TimeSlot.new t
        slot.place_area = self
        a << slot
      end
      a
    end
  end
  
  def time_slots_at day
    self.time_slots.find_all{|ts| ts.start_at.same_day? day}
  end

  def title
    english? ? title_en : @raw_data.title
  end

end
