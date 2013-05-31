# -*- coding: utf-8 -*-
class SpeakerViewCell < UIView
  include BW::KVO

  attr_accessor :imageView, :nameLabel
  attr_accessor :speaker
  

  def initWithFrame frame
    super
    setup
    self
  end

  def dealloc
    speaker = nil
  end

  def speaker= speaker
    unobserve @speaker, "icon" if @speaker
    
    @speaker = speaker

    if @speaker
      observe @speaker, "icon" do |old, new|
        set_icon
      end
    end

    if @speaker
      self.nameLabel.text = @speaker.name
      if @speaker.icon
        set_icon
      else
        @speaker.begin_load_icon
      end
    end
  end
  
  def layoutSubviews
    super
    f = self.frame
    frame = CGRectMake(0, 0, f.size.height, f.size.height)
    frame = CGRectInset(frame, 2, 2)
    imageView.frame = frame
    frame.origin.x = CGRectGetMaxX(frame) + 4
    frame.size.width = f.size.width - imageView.frame.size.width
    frame = CGRectInset(frame, 4, 0)
    nameLabel.frame = frame
  end

  private
  
  def font_name
    "GillSans"
  end
  
  def set_icon
    imageView.image = @speaker.thumb_icon
  end

  def setup
    # image view
    i = UIImageView.new
    i.clipsToBounds = true
    i.backgroundColor = :clear.uicolor
    l = i.layer
    l.cornerRadius = 8
    l.borderColor = :lightgray.uicolor.cgcolor
    l.borderWidth = 1
    self << i
    self.imageView = i
    
    # name label
    l = UILabel.alloc.initWithFrame CGRectZero
    l.font = font_name.uifont(14)
    l.backgroundColor = :clear.uicolor
    self << l
    self.nameLabel = l
  end

end

