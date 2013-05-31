# -*- coding: utf-8 -*-
class TimeTableViewController < UIViewController

  include BW::KVO
  
  attr_accessor :timetableView # @type_info TimeTableView

  def kvo_keys
    %w(events current_event english cache_data_cleared)
  end
  
  def dealloc
    kvo_keys.each do |key|
      unobserve(@data_manager, key.to_sym)
    end

    TimeHeaderViewDidTapNotification.remove_observer self
    UIApplicationDidBecomeActiveNotification.remove_observer(self)
  end
  
  def viewDidLoad
    super
    @data_manager = DataManager.shared_manager
    kvo_keys.each do |key|
      observe(@data_manager, key.to_sym) do |old_value, new_value|
        self.timetableView.reloadData
      end
    end
    
    # twitter button
    button = UIButton.alloc.initWithFrame [[0, 0], [25, 25]]
    button.setImage "twitter".uiimage, forState:UIControlStateNormal
    button.addTarget self, action:"didSelectTwitter:", forControlEvents:UIControlEventTouchUpInside
    twitterButton = UIBarButtonItem.alloc.initWithCustomView button

    # facebook button
    button = UIButton.alloc.initWithFrame [[0, 0], [25, 25]]
    button.setImage "facebook".uiimage, forState:UIControlStateNormal
    button.addTarget self, action:"didSelectFacebook:", forControlEvents:UIControlEventTouchUpInside
    facebookButton = UIBarButtonItem.alloc.initWithCustomView button

    # map button
    button = UIButton.alloc.initWithFrame [[0, 0], [25, 25]]
    button.setTitle "🌏", forState:UIControlStateNormal
    button.addTarget self, action:"didSelectMap:", forControlEvents:UIControlEventTouchUpInside
    mapButton = UIBarButtonItem.alloc.initWithCustomView button

    spaceButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem UIBarButtonSystemItemFixedSpace, target:self, action:nil

    navigationItem.leftBarButtonItems = [navigationItem.leftBarButtonItem, spaceButton, twitterButton, spaceButton, facebookButton, spaceButton, mapButton]


    @nowButton = UIBarButtonItem.titled('Now'._, :plain) {
      timetableView.move_to_now
      hide_navigation_bar
    }
    navigationItem.rightBarButtonItems = [navigationItem.rightBarButtonItem, spaceButton, @nowButton]

    UIApplicationDidBecomeActiveNotification.add_observer(self, "didBecomeActive:")
    
    TimeHeaderViewDidTapNotification.add_observer self, "time_header_view_did_tap:"
    self.timetableView.reloadData
  end
  
  def didSelectTwitter sender
    if timetableView.event.twitter_tag
      url = "https://twitter.com/search?q=#{timetableView.event.twitter_tag.escape_url}".nsurl
    else
      url = "https://twitter.com/".nsurl
    end
    c = CIALBrowserViewController.alloc.initWithURL url
    c.enabledSafari = true
    self.navigationController << c
  end
  
  def didSelectFacebook sender
    url = "https://facebook.com/".nsurl
    c = CIALBrowserViewController.alloc.initWithURL url
    c.enabledSafari = true
    self.navigationController << c
  end
  
  def didSelectMap sender
    q = timetableView.event.places.first.address ? timetableView.event.places.first.address.escape_url : ""
    url = "https://maps.google.com/maps?q=#{q}".nsurl
    c = CIALBrowserViewController.alloc.initWithURL url
    c.enabledSafari = true
    self.navigationController << c
  end
  
  def didBecomeActive notification
    timetableView.move_to_now
  end
  
  def show_navigation_bar(schedule = true)
    @nowButton.enabled = timetableView.event.take_place?
    self.navigationController.setNavigationBarHidden false, animated:true
    schedule_timer if schedule
  end
  
  def hide_navigation_bar
    self.navigationController.setNavigationBarHidden true, animated:true
  end
  
  def time_header_view_did_tap notification
    if self.navigationController.navigationBarHidden?
      show_navigation_bar
    else
      hide_navigation_bar
    end
  end

  def schedule_timer
    @timer.invalidate if @timer
    @timer = 5.second.later do
      hide_navigation_bar
    end
  end
  
  def reschedule_timer
    if @timer
      @timer.invalidate if @timer
      @timer = 5.second.later do
        hide_navigation_bar
      end
    end
  end
  
  def stop_scheduled_timer
    @timer.invalidate if @timer
    @timer = nil
  end
  

  def viewDidAppear animated
    super
    hide_navigation_bar
    unless @first_time
      timetableView.move_to_now
      @first_time = true
    end
  end

  def viewWillDisappear animated
    super
    stop_scheduled_timer
  end
  
end

class NavigationController < UINavigationController

  def shouldAutorotateToInterfaceOrientation interfaceOrientation
    true
  end

end
