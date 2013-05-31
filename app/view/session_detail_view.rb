# -*- coding: utf-8 -*-
class SessionDetailView < UIScrollView

  attr_accessor :controller   # type_info SessionDetailViewController
  attr_accessor :baseView
  attr_accessor :dateLabel, :titleLabel, :speaker_views
  attr_accessor :abstractLabel, :subsession_views

  def awakeFromNib
    setup_views
    setNeedsLayout
  end
  
  def clean
    speaker_views.each do |s|
      s.speaker = nil
    end
    subsession_views.each do |s|
      s.session = nil
    end
  end

  def dealloc
    controller = nil
  end

  def session
    controller.session
  end
  
  def controller= controller
    setNeedsLayout
  end
  
  def layoutSubviews
    super
    f = superview.bounds
    f = CGRectInset(f, 4, 4)
    
    # date lable
    f = CGRectInset(f, 8, 8)
    frame = f.dup
    t = dateLabel.text
    unless t.blank?
      font = dateLabel.font
      s = t.sizeWithFont font, constrainedToSize:CGSizeMake(f.size.width, 10000)
      s.width = f.size.width
      frame.size = s
    end
    dateLabel.frame = frame
    
    # title label
    frame.origin.y = CGRectGetMaxY(frame) + 12
    frame.size = CGSizeZero
    t = titleLabel.text
    unless t.blank?
      font = titleLabel.font
      s = t.sizeWithFont font, constrainedToSize:CGSizeMake(f.size.width, 10000)
      s.width = f.size.width
      frame.size = s
    end
    titleLabel.frame = frame
    frame.origin.y = CGRectGetMaxY(frame) + 12
    
    # abstract label
    frame.origin.x = f.origin.x
    l = abstractLabel
    t = l.text
    unless t.blank?
      font = l.font
      s = t.sizeWithFont font, constrainedToSize:CGSizeMake(f.size.width, 10000)
      s.width = f.size.width
      frame.size = s
    end
    l.frame = frame
    frame.origin.y = CGRectGetMaxY(frame) + 12
    
    # sessions cell
    frame.origin.x = f.origin.x + 16
    frame.size = CGSizeMake(f.size.width, 60)
    frame.size.width -= 16
    frame = CGRectInset(frame, 8, 0)
    @subsession_views.each do |v|
      v.frame = frame
      frame.origin.y = CGRectGetMaxY(frame) + 2
    end
    frame.origin.y += 10
    
    # speakers cell
    frame.origin.x = f.origin.x
    frame.size = CGSizeMake(f.size.width, 44)
    frame = CGRectInset(frame, 8, 0)
    size = frame.size
    @speaker_views.each do |v|
      v.frame = frame
      v.layoutSubviews
      frame = v.frame
      frame.origin.y = CGRectGetMaxY(frame) + 2
      frame.size = size
    end
    
    # decide content size
    h = [frame.origin.y + 12, superview.bounds.size.height].max
    self.baseView.frame = [[0, 0], [self.bounds.size.width, h]]
    self.contentSize = self.baseView.frame.size unless CGSizeEqualToSize(self.contentSize, self.baseView.frame.size)

    # base view
    l = self.baseView.layer
    l.borderColor = session.tint_color.mix_with(:black.uicolor, 0.2).cgcolor
    c = "#f8fee5".uicolor
    self.baseView.backgroundColor = c    
  end
  
  def font_name
    "Georgia"
  end
  
  def setup_views
    # base view
    self.baseView = UIView.new
    self << self.baseView
    # set layer propeties
    l = self.baseView.layer
    l.cornerRadius = 16
    l.borderWidth = 1
    
    # dateLabel
    l = UILabel.new
    l.backgroundColor = :clear.uicolor
    l.numberOfLines = 0
    l.font = font_name.uifont(14)
    l.text = self.session.time_slot.time_range_text
    self << l
    self.dateLabel = l
    
    # titleLable
    l = UILabel.new
    l.backgroundColor = :clear.uicolor
    l.numberOfLines = 0
    l.font = font_name.uifont(21)
    l.text = self.session.title
    self << l
    self.titleLabel = l
    
    # speaker view cell
    a = []
    self.session.speakers.each do |s|
      v = SpeakerDetailViewCell.alloc.initWithFrame CGRectZero
      v.speaker = s
      a << v
      self << v
    end
    @speaker_views = a
    
    # abstract view
    l = UILabel.new
    l.backgroundColor = :clear.uicolor
    l.numberOfLines = 0
    l.font = font_name.uifont(16)
    l.text = self.session.abstract
    self << l
    self.abstractLabel = l

    # session view cell
    a = []
    self.session.sessions.each do |s|
      v = SessionViewCell.load_from_nib
      v.session = s
      v.bar_hidden = v.session == self.session.sessions.last
      a << v
      self << v
    end
    self.subsession_views = a

  end

end

