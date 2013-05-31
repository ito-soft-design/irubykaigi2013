# -*- coding: utf-8 -*-
class TimeSlotViewCell < RKView

  attr_accessor :time_slot

  attr_accessor :tint_color
  
  TimeLabelWidth = 60
  
  def initWithFrame frame
    super
    setup
    self
  end

  def initWithCorder decode
    super
    setup
    self
  end

  def difftime_to_point difftime
    HeightPerHour * difftime / 3600
  end
  
  def time_slot= time_slot
    @time_slot = time_slot
    
    @session_view_cells ||= []
    while @session_view_cells.size < @time_slot.sessions.size
      v = SessionViewCell.load_from_nib
      self << v
      @session_view_cells << v
    end
    @session_view_cells.each_with_index do |v, i|
      if i < @time_slot.sessions.size
        v.session = @time_slot.sessions[i]
        v.bar_hidden = v.session == @time_slot.sessions.last
      else
        v.removeFromSuperview
      end
    end
    @time_label.text = @time_slot.start_at_text
    
    s = @time_slot.sessions.find{|s| s.kind == "session"}
    if s
      self.tint_color = s.tint_color
    else
      self.tint_color = @time_slot.sessions.first ? @time_slot.sessions.first.tint_color : :white.uicolor
    end
    setNeedsLayout
  end

  def layoutSubviews
    super
    return unless time_slot
    
    self.hidden = @time_slot.sessions.size == 0
    
    f = superview.bounds
    offset = time_slot.start_at.start_of_day + time_slot.event.time_range[0]
    f.origin.y = difftime_to_point(time_slot.start_at -  offset)
    f.size.height = difftime_to_point(time_slot.end_at - time_slot.start_at)
    f = CGRectInset(f, 2, 0)
    f.size.height -= 2
    self.frame = f
    
    f = self.bounds
    @time_label.frame = [[f.origin.x + 3, f.origin.y + 0], [50, 18]]

    h = f.size.height / @session_view_cells.size
    w = f.size.width
    @session_view_cells.each_with_index do |v, i|
      f = CGRectMake(0, i * h, w, h)
      f = CGRectInset(f, 8, 0)
      v.frame = f
    end

    # set tint color
    l = self.layer
    c = self.tint_color
    l.borderColor = c.mix_with(:black.uicolor, 0.2).cgcolor
    l.colors = [c.cgcolor, c.cgcolor]
  end

  private
  
  def setup
    self.clipsToBounds = true
    
    l = self.layer
    l.cornerRadius = 4
    l.borderWidth = 1

    @time_label ||= begin
      l = UILabel.alloc.initWithFrame CGRectZero
      l.font = "GillSans".uifont(16)
      l.textColor = "#ff68a1".uicolor
      l.backgroundColor = :clear.uicolor
      l.textAlignment = NSTextAlignmentRight
      self << l
      l
    end
  
  end
  

end

