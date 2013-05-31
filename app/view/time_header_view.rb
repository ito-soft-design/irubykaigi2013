# -*- coding: utf-8 -*-

TimeHeaderViewDidTapNotification = "TimeHeaderViewDidTapNotification"

class TimeHeaderView < RKView

  attr_accessor :titleLabel
  
  LABEL_MERGIN = 4

  def initWithFrame frame
    super
    setup_if_needs
    @inital_frame = self.frame
    self
  end

  def awakeFromNib
    setup_if_needs
  end

  def layoutSubviews
    super
    
    setup_if_needs

    f = self.frame
    f.origin.y = superview.contentOffset.y + @inital_frame.origin.y
    self.frame = f

    unless titleLabel.text.blank?
      frame = self.frame
      b = CGRectIntersection(self.frame, superview.bounds)
      b = CGRectInset(b, LABEL_MERGIN, 0)
      font = titleLabel.font
      size = titleLabel.text.sizeWithFont font
    
      x = b.origin.x
      y = (b.size.height - size.height) / 2
      w = frame.size.width > size.width ? size.width : frame.size.width
      h = b.size.height
      f = CGRectMake(x, y, w, h)
      f.origin.x = CGRectGetMaxX(frame) - LABEL_MERGIN - w if (CGRectGetMaxX(frame) - LABEL_MERGIN) < CGRectGetMaxX(f)
      # convert frame to bounds
      f.origin.x -= frame.origin.x
      titleLabel.frame = f
    end
  end

  private
  
  def setup_if_needs
    return if @setuped
    
    @setuped = true

    l = UILabel.alloc.initWithFrame CGRectZero
    l.font = "COPPERPLATE".uifont(16)
    l.backgroundColor = :clear.uicolor
    l.textColor = :white.uicolor
    self << l
    self.titleLabel = l
    self.alpha = 0.8
    
    l = self.layer
    b = :black.uicolor
    w = :white.uicolor
    l.colors = [b.mix_with(w.uicolor, 0.3).cgcolor, b.cgcolor]
    
    on_tap(taps:1, fingers:1) do
      TimeHeaderViewDidTapNotification.post_notification(self)
    end
    
  end

end

