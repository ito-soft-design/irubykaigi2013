# -*- coding: utf-8 -*-

# refecences
# http://stackoverflow.com/questions/1105647/deactivate-uiscrollview-decelerating
# http://stackoverflow.com/questions/5041160/uiscrollview-horizontal-scrolling-disable-left-scroll
#

class TimeTableView < UIScrollView

  include BW::KVO
  
  attr_accessor :event
  attr_accessor :timeTableViewController # @type_info TimeTableViewController
  
  HEADER_HEIGHT = 30
  
  def data_manager
    @data_manager ||= DataManager.shared_manager
  end
  
  def event
    self.data_manager.current_event
  end
  
  def reloadData
    return if event.nil?
    setup_views
    setNeedsLayout
  end
  
  def scrollViewWillBeginDragging scrollView
    timeTableViewController.reschedule_timer
    @start_offset = scrollView.contentOffset
    @direction = nil
  end

  def scrollViewDidScroll scrollView
    timeTableViewController.reschedule_timer
    point = scrollView.contentOffset
    if @start_offset
      dx = point.x - @start_offset.x
      dy = point.y - @start_offset.y
      
      unless @direction
        d = [dx.abs, dy.abs].max
        if d > 1
          if dx.abs == d
            @diff = dx
            @direction = "Horizontal"
          else
            @diff = dy
            @direction = "Vertical"
          end
        end
      end
    end
      
    case @direction
    when "Horizontal"
      self.contentOffset = CGPointMake(@start_offset.x + dx, @start_offset.y)
    when "Vertical"
      self.contentOffset = CGPointMake(@start_offset.x, @start_offset.y + dy)
    end
  end

  def scrollViewDidEndDragging scrollView, willDecelerate:decelerate
    fit_to_page @diff unless decelerate
  end
  
  def scrollViewWillBeginDecelerating scrollView
    fit_to_page @diff if @direction == "Horizontal"
  end

  def viewForZoomingInScrollView scrollView
    nil
  end
  
  def scrollViewDidEndZooming scrollView, withView:view, atScale:scale
  end

  def fit_to_page diff = 0
    point = self.contentOffset
    x = point.x + 160
    if @diff < 0
      x -= 160
    else
      x += 160
    end

    maxx = contentSize.width - 320
    x = maxx if x > maxx
    x = 0 if x < 0
    x = (x / 320).to_i * 320
    y = point.y
    self.setContentOffset(CGPointMake(x, y), animated:true)
  end

  def layoutSubviews
    super
    self.subviews.each do |v|
      v.layoutSubviews if v.is_a? TimeHeaderView
    end
  end

  def move_to_now
    self.subviews.each do |v|
      case v
      when TimeLaneView
        view = v.view_for_now?
        if view
          frame = view.convertRect view.bounds, toView:self
          x = (frame.origin.x / 320).to_i * 320
          y = frame.origin.y
          y = [y, 0].max
          y = [y, self.contentSize.height - self.bounds.size.height + HEADER_HEIGHT * 3].min
          y -= HEADER_HEIGHT * 3
          @diff = 0
          setContentOffset CGPointMake(x, y), animated:true
          break
        end
      end
    end
  end

  private
  
  def setup_views
    return if self.event.nil?
    
    directionalLockEnabled = true
    
    # contentOffsetがdelegate methodが呼ばれる事で正常にセットされないので一旦nilにし呼ばれない様にする
    self.delegate = nil
    self.backgroundColor = "#f8fee5".uicolor
    
    # clear views
    self.subviews.each do |v|
      v.removeFromSuperview unless v.is_a? UIImageView
    end
    
    offset = 0
    event.days.times do |d|
      event.places.each do |p|
        p.place_areas.each do |pa|
          f = [[offset, 0], [320, 24 * HeightPerHour]]
          s = TimeLaneView.alloc.initWithFrame f
          s.place_area = pa
          s.date = event.start_at + d.days
          self << s
          offset = CGRectGetMaxX(s.frame)
        end
      end
    end
    hour = (event.time_range[1] - event.time_range[0]) / 3600
    h = hour * HeightPerHour
    h = [self.frame.size.height, h].max
    ex_contentSize = self.contentSize
    self.contentSize = CGSizeMake(offset, h + 44)   # 44はタイトルバーの分？ 合わなくて調整した分
    self.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT * 3, 0, 0, 0)
    unless CGSizeEqualToSize(ex_contentSize, self.contentSize)
      self.contentOffset = CGPointMake(0, - HEADER_HEIGHT * 3)
    end

    # TODO: スケールは準備だけでまだ使ってない
    self.maximumZoomScale = 2
    self.minimumZoomScale = [1,
                             self.bounds.size.width / self.contentSize.width,
                             self.bounds.size.height / self.contentSize.height].min

    # prepare header views
    offset = 0
    lanes = event.number_of_lanes
    event.days.times do |d|
      w = 320 * lanes
      f = [[offset, 0], [w, HEADER_HEIGHT]]
      v = TimeHeaderView.alloc.initWithFrame f
      v.titleLabel.text = (event.start_at + d.days).string_with_style(:medium) + " "  + event.title
      self << v
      event.places.each do |p|
        w = 320 * p.place_areas.size
        f = [[offset, HEADER_HEIGHT], [w, HEADER_HEIGHT]]
        v = TimeHeaderView.alloc.initWithFrame f
        v.titleLabel.text = p.name
        self << v
        p.place_areas.each do |pa|
          w = 320
          f = [[offset, HEADER_HEIGHT * 2], [w, HEADER_HEIGHT]]
          v = TimeHeaderView.alloc.initWithFrame f
          v.titleLabel.text = pa.title
          self << v
          offset += w
        end
      end
    end
    
    # dummy header
    3.times do |i|
      # left
      s = UIScreen.mainScreen.bounds.size
      w = [s.width, s.height].max
      f = [[-w, i * HEADER_HEIGHT], [w, HEADER_HEIGHT]]
      v = TimeHeaderView.alloc.initWithFrame f
      self << v
      # right
      f = [[offset, i * HEADER_HEIGHT], [w, HEADER_HEIGHT]]
      v = TimeHeaderView.alloc.initWithFrame f
      self << v
    end

    self.delegate = self
  end

end

