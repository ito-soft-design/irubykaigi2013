# -*- coding: utf-8 -*-
class SessionViewCell < UIView
  include BW::KVO

  attr_accessor :titleLabel   # @type_info UILabel
  attr_accessor :speakerLabel # @type_info UILabel
  attr_accessor :imageView    # @type_info UIImageView
  attr_accessor :bar          # @type_info UIView
  attr_accessor :disclosureIndicatorImageView  # @type_info UIImageView

  attr_accessor :session
  
  def self.load_from_nib
    NSBundle.mainBundle.loadNibNamed("SessionViewCell", owner:self, options:nil)[0]
  end

  def initWithFrame frame
    super
    setup
    self
  end

  def navigationController
    app = UIApplication.sharedApplication
    app.keyWindow.rootViewController
  end

  def timeTableViewController
    navigationController.viewControllers.each do |c|
      return c if c.is_a? TimeTableViewController
    end
  end

  def root_view
    navigationController.topViewController.view
  end

  def awakeFromNib
    setup
  end

  def dealloc
    session = nil
    @timer.invalidate if @timer
  end

  def session= session
    if @session
      @session.speakers.each do |s|
        unobserve s, "icon" if s
      end
    end
    
    @session = session
    
    if @session
      @session.speakers.each do |s|
        if s
          observe s, "icon" do |old, new|
            if new
              @icons ||= []
              scale = UIScreen.mainScreen.scale
              @icons << new.scale_to(CGSizeMake(30 * scale, 30 * scale))
              show_icon
            end
          end
          s.begin_load_icon
        end
      end
    end

    titleLabel.text = session.title
    titleLabel.textColor = session.kind == "session" ? :darkgray.uicolor : "#ff68a1".uicolor

    lang = []
    lang << "JA" if /japanese/i =~ session.language
    lang << "EN" if /english/i =~ session.language
    speakerLabel.text = session.speakers.map{|s| s.name}.join(",")
    speakerLabel.text += " [" + lang.join("|") + "]" unless lang.size == 0
  end

  def show_icon
    if @icons.size == 1
      self.imageView.image = @icons.first
    else
      @timer.invalidate if @timer
      @timer = 3.sec.every do
        self.imageView.image = @icons.first
        @icons << @icons.first
        @icons.shift
      end
    end
  end

  def bar_hidden= hidden
    self.bar.hidden = hidden
  end

  TIME_LABEL_WIDTH = 60

  def layoutSubviews
    super

    frame = self.bounds
    has_speaker = frame.size.height >= 44
    has_speaker = false if speakerLabel.text.length == 0
    
    font = titleLabel.font
    titleLabel.font = font
    if has_speaker
      f = speakerLabel.frame
      w = frame.size.width - f.origin.x - 20
      speakerLabel.frame = [[f.origin.x, frame.size.height - 21],[w, 21]]
      f = titleLabel.frame
      titleLabel.frame = [[f.origin.x, 0], [w, frame.size.height - 22]]
      imageView.frame = [[(TIME_LABEL_WIDTH - 30) / 2, frame.size.height - 35],[30, 30]]
      speakerLabel.hidden = false
    else
      f = frame.dup
      f.origin.x += TIME_LABEL_WIDTH
      f.size.height = frame.size.height
      f.size.width = f.size.width - f.origin.x - 20
      f = CGRectInset(f, 0, 2)
      f.size.width -= 20
      titleLabel.frame = f
      speakerLabel.hidden = true
    end
    
    # 1行で収まるか判断
    if titleLabel.text
      size = titleLabel.text.sizeWithFont font
      f = titleLabel.frame
      rate = [f.size.width / size.width, f.size.height / size.height].min
      rate = rate > 1.0 ? 1.0 : rate
      rate = rate < 0.9 ? 0.9 : rate
      unless rate == 1.0
        font = UIFont.fontWithName font.fontName, size:font.pointSize * rate
        titleLabel.font = font
      end
    end
    
    f = disclosureIndicatorImageView.frame
    f.origin = CGPointMake(frame.size.width - f.size.width, (frame.size.height - f.size.height) / 2)
    disclosureIndicatorImageView.frame = f
    disclosureIndicatorImageView.hidden = !disclosure_indicator_visible?
  end

  private

  def disclosure_indicator_visible?
    case self.session.kind
    when "session", "party"
      true
    else
      false
    end
  end

  def font_name
    "GillSans"
  end
  
  def setup
    self.clipsToBounds = false
    
    self.imageView.clipsToBounds = true
    l = self.imageView.layer
    l.cornerRadius = 4

    self.backgroundColor = :clear.uicolor
    
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.font = font_name.uifont(17)

    speakerLabel.font = font_name.uifont(14)
    speakerLabel.textColor = :darkgray.uicolor

    self.on_tap do
      if disclosure_indicator_visible?
        @detail_controller = controller_by_name "SessionDetailViewController"
        @detail_controller.session = self.session
        timeTableViewController.show_navigation_bar(false)
        navigationController << @detail_controller
      end
    end
  end


end
