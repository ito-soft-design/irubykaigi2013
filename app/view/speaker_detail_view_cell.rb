# -*- coding: utf-8 -*-
class SpeakerDetailViewCell < SpeakerViewCell

  attr_accessor :subtitleLabel, :abstractLabel, :githubButton, :twitterButton

  def speaker= speaker
    super

    if @speaker
      a = []
      a << @speaker.twitter if @speaker.twitter
      a << @speaker.organizations.map{|o| o.name}.join(" / ")
      a << @speaker.location if @speaker.location
      self.subtitleLabel.text = a.join("\n")
      self.abstractLabel.text = @speaker.abstract
      self.twitterButton.hidden = @speaker.twitter.nil?
      self.githubButton.hidden = @speaker.github.nil?
    end
  end
  

  def layoutSubviews
    super
    f = self.frame
    
    # image view
    frame = CGRectMake(0, 0, 100, 100)
    frame = CGRectInset(frame, 2, 2)
    imageView.frame = frame
    imageView.hidden = imageView.image.nil?
    
    # name label
    frame.origin.x = CGRectGetMaxX(frame) + 4
    frame.size.width = f.size.width - imageView.frame.size.width - 4
    frame = CGRectInset(frame, 4, 0)
    width = frame.size.width
    # adjust frame to name text
    l = nameLabel
    t = l.text
    unless t.blank?
      font = l.font
      s = t.sizeWithFont font, constrainedToSize:CGSizeMake(frame.size.width, 10000)
      s.width = [frame.size.width, s.width].min
      frame.size = s
    end
    l.frame = frame
    frame.origin.y = CGRectGetMaxY(frame) + 2
    frame.size.width = width
 
    # subtitle label
    l = subtitleLabel
    frame.size.height = 48
    t = l.text
    unless t.blank?
      font = l.font
      s = t.sizeWithFont font, constrainedToSize:CGSizeMake(frame.size.width, 10000)
      frame.size = s
    end
    l.frame = frame
    frame.origin.y = CGRectGetMaxY(frame) + 12
    
    # github button
    b = githubButton
    unless b.hidden?
      frame.origin.x += 44
      frame.size = CGSizeMake(44, 22)
      b.frame = frame
    end

    # twitter button
    b = twitterButton
    unless b.hidden?
      frame.origin.x += 44
      frame.size = CGSizeMake(44, 22)
      b.frame = frame
    end
    y = CGRectGetMaxY(frame) + 10
    frame.origin.x = nameLabel.origin.x
    frame.origin.y = y
    frame.size.width = width

    # adjust frame to abstract text
    l = abstractLabel
    t = l.text
    unless t.blank?
      font = l.font
      s = t.sizeWithFont font, constrainedToSize:CGSizeMake(frame.size.width, 10000)
      s.width = [frame.size.width, s.width].min
      frame.size = s
    end
    l.frame = frame.dup
    frame.origin.y = CGRectGetMaxY(frame) + 12
    frame.size.width = width
    
    # adjust self frame
    f.size.height = [f.size.height,
                     CGRectGetMaxY(abstractLabel.frame) + 12].max
    self.frame = f
  end


  def navigationController
    app = UIApplication.sharedApplication
    app.keyWindow.rootViewController
  end

  def show_web_controller_with_url url
    c = CIALBrowserViewController.alloc.initWithURL url
    c.enabledSafari = true
    self.navigationController << c
  end

  def didClickTwitterButton sender
    show_web_controller_with_url "http://twitter.com/#{@speaker.twitter.gsub(/@/, "")}".nsurl
  end

  def didClickGithubButton sender
    show_web_controller_with_url "https://github.com/#{@speaker.github}".nsurl
  end

  private
  
  def set_icon
    imageView.image = @speaker.icon
  end

  def setup
    super
    l = self.nameLabel
    l.font = font_name.uifont(24)
    l.numberOfLines = 0

    # subtitle label
    l = UILabel.new
    l.font = font_name.uifont(14)
    l.backgroundColor = :clear.uicolor
    l.numberOfLines = 0
    self << l
    self.subtitleLabel = l

    # abstract label
    l = UILabel.new
    l.backgroundColor = :clear.uicolor
    l.numberOfLines = 0
    l.font = font_name.uifont(14)
    self << l
    self.abstractLabel = l
    
    # twitter button
    b = UIButton.custom
    b.setImage "twitter.png".uiimage, forState:UIControlStateNormal
    b.setTitleColor :black.uicolor, forState:UIControlStateNormal
    b.addTarget self, action:"didClickTwitterButton:", forControlEvents:UIControlEventTouchUpInside
    b.titleLabel.font = font_name.uifont(14)
    b.titleLabel.adjustsFontSizeToFitWidth = true
    b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
    self << b
    self.twitterButton = b

    # github button
    b = UIButton.custom
    b.setImage "github.png".uiimage, forState:UIControlStateNormal
    b.setTitleColor :black.uicolor, forState:UIControlStateNormal
    b.addTarget self, action:"didClickGithubButton:", forControlEvents:UIControlEventTouchUpInside
    b.titleLabel.font = font_name.uifont(14)
    b.titleLabel.adjustsFontSizeToFitWidth = true
    b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
    self << b
    self.githubButton = b
  end

end
