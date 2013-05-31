# -*- coding: utf-8 -*-

HeightPerHour = 120

class TimeLaneView < RKView

  attr_accessor :place_area, :date
  attr_accessor :header_view, :time_slot_views, :time_view

  TimeMemoryAlpha = 0.5

  def place_area= area
    @place_area = area
    @time_slots = nil
    setNeedsLayout
  end
  
  def date= date
    @date = date
    @time_slots = nil
    setNeedsLayout
  end
  
  def time_slots
    @time_slots ||= begin
      if place_area && date
        @place_area.time_slots_at date
      else
        []
      end
    end
  end
  
  def reuseable_cell
    @reuseable_cell ||= []
  end
  
  def get_free_cell
  end
  
  def release_cell cell
  end

  def layoutSubviews
    super
    setup unless @setuped

    if place_area && date
    
      self.subviews.each do |v|
        v.setNeedsLayout
      end
      
    end
    
    f = self.bounds
    @time_labels.each_with_index do |l, index|
      /(\d{1,2}):(\d{2})/ =~ l.text
      h = $1.to_i
      y = (h * 3600 - place_area.event.time_range[0]) * HeightPerHour / 3600
      @memory_bars[index].frame = [[50, y], [20, 1]]
      l.frame = [[5, y + 0], [50, 18]]
    end
    
    y = - place_area.event.time_range[0] * HeightPerHour / 3600
    height = 24 * HeightPerHour
    @lane_separate_line.frame = [[0, y], [1, height]]
    @time_separate_line.frame = [[60, y], [1, height]]
  end

  def view_for_now?
    now = Time.now
    self.subviews.each do |v|
      case v
      when TimeSlotViewCell
        if v.time_slot.start_at <= now && now < v.time_slot.end_at
          return v
        end
      end
    end
    return nil
  end

  private
  
  def setup
    @setuped = true

    # clear views
    self.subviews.each do |v|
      v.removeFromSuperview
    end

    setup_time_line

    time_slots.each do |s|
      c = TimeSlotViewCell.alloc.initWithFrame CGRectZero
      c.time_slot = s
      self << c
    end
    
  end
    
  def setup_time_line
    @lane_separate_line = UIView.alloc.initWithFrame CGRectZero
    @lane_separate_line.backgroundColor = :lightgray.uicolor
    @lane_separate_line.alpha = TimeMemoryAlpha
    self << @lane_separate_line
    
    @time_separate_line = UIView.alloc.initWithFrame CGRectZero
    @time_separate_line.backgroundColor = :lightgray.uicolor
    @time_separate_line.alpha = TimeMemoryAlpha
    self << @time_separate_line
    
    start_hour = (place_area.event.time_range[0] / 3600).to_i
    end_hour = (place_area.event.time_range[1] / 3600).to_i
    @time_labels = (start_hour..end_hour).map do |t|
      l = UILabel.alloc.initWithFrame CGRectZero
      l.font = "GillSans".uifont(16)
      l.alpha = TimeMemoryAlpha
      l.backgroundColor = :clear.uicolor
      l.textAlignment = NSTextAlignmentRight
      l.textColor = :lightgray.uicolor
      l.text = "#{t}:00"
      self << l
      l
    end
    @memory_bars = (start_hour..end_hour).map do |t|
      v = UIView.alloc.initWithFrame CGRectZero
      v.backgroundColor = :lightgray.uicolor
      v.alpha = TimeMemoryAlpha
      self << v
      v
    end
  end

end

