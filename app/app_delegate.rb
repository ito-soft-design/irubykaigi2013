class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    sb = UIStoryboard.storyboardWithName "Storyboard", bundle:nil
    @window.rootViewController = sb.instantiateInitialViewController
    @window.rootViewController.view.backgroundColor = "#f8fee5".uicolor
    @window.makeKeyAndVisible
    
    10.min.every do
      DataManager.shared_manager.begin_load_events
    end
    DataManager.shared_manager.begin_load_events
    
    NSTimeZone.setDefaultTimeZone(NSTimeZone.timeZoneWithName("Asia/Tokyo"))

    true
  end
end

def controller_by_name name
  sb = UIStoryboard.storyboardWithName "Storyboard", bundle:nil
  sb.instantiateViewControllerWithIdentifier name
end
