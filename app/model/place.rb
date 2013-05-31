# -*- coding: utf-8 -*-
class Place < HashModel

  attr_accessor :event
  
  def place_areas
    @place_areas ||= begin
      a = []
      @raw_data.place_areas.each do |p|
        area = PlaceArea.new p
        area.place = self
        a << area
      end
      a
    end
  end
  
  def name
    english? ? name_en : @raw_data.name
  end

  def address
    english? ? address_en : @raw_data.address
  end

  def address
    english? ? address_en : @raw_data.address
  end
  
end
