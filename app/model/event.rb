# -*- coding: utf-8 -*-
class Event < HashModel

  def self.parse json_string
    BW::JSON.parse(json_string).map{|e| Event.new e }.to_object
  end

  def take_place?
    now = Time.now
    start_at <= now and now < end_at
  end

  def start_at
    @start_at ||= begin
      a = self.start_on.split('-')
      NSDate.from_components(year:a[0], month:a[1], day:a[2]).start_of_day
    end
  end
  
  def end_at
    @end_at ||= begin
      a = self.end_on.split('-')
      NSDate.from_components(year:a[0], month:a[1], day:a[2]).end_of_day
    end
  end
  
  def days
    ((end_at - start_at) / 1.day).to_i
  end
  
  def places
    @places ||= begin
      a = []
      @raw_data.places.each do |p|
        place = Place.new p
        place.event = self
        a << place
      end
      a
    end
  end

  def time_range
    @time_range ||= begin
      a = begin
        self.places.map do |p|
          p.place_areas.map do |pa|
            pa.time_slots.map do |ts|
              [ts.start_at - ts.start_at.start_of_day, ts.end_at - ts.end_at.start_of_day]
            end
          end
        end.flatten
      end
      index = -1
      start_time = a.find_all{|e| index += 1; index % 2 == 0 ? e : nil}.min
      end_time = a.find_all{|e| index += 1; index % 2 == 1 ? e : nil}.max
      [start_time, end_time]
    end
  end

  def number_of_lanes
    self.places.map{|p| p.place_areas.size}.inject{|sum,e| sum + e}
  end

  def past? day = Time.new
    self.end_at < day
  end

  def title
    english? ? title_en : @raw_data.title
  end

end
