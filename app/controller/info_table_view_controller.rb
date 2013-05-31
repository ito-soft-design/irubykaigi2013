# -*- coding: utf-8 -*-
class InfoTableViewController < UITableViewController
  include BW::KVO

  INFO_SECTION        = 0
  SETTING_SECTION     = 1
  VERSION_SECTION     = 2
  COPYRIGHT_SECTION   = 3
  
  NUMBER_OF_SECTION   = 4

  SETTING_ENGLISH_ROW   = 0
  SETTING_CLEAR_CACHE   = 1


  def title
    "Information"._
  end

  def viewDidLoad
    super
    
    @info_source = [
      { title:"OVERVIEW"._, url:"http://itosoft.herokuapp.com/irubykaigi13/overview" },
      { title:"SUPPORT"._, url:nil },
      { title:"PRODUCTS"._, url:"http://itosoft.herokuapp.com" },
      { title:"ABOUT_US"._, url:"http://iphone.itosoft.com" }
    ]
    @copyright_source = [
      { title:"COPYRIGHT"._, url:"http://itosoft.herokuapp.com/irubykaigi13/copyright" },
      { title:"ACKNOWLEDGEMENT"._, url:"http://itosoft.herokuapp.com/irubykaigi13/acknowledgement" }
    ]

    self.title = "Information"._
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.titled("Close"._) {
      unless @data_clear_switch
        self.dismissViewControllerAnimated true, completion:nil
      end
    }

    observe(DataManager.shared_manager, :cache_data_cleared) do |old_value, new_value|
      if new_value && @data_clear_switch
        @data_clear_switch.on = false
        SVProgressHUD.dismiss
        @data_clear_switch = nil
      end
    end
  end


  def dealloc
    unobserve(DataManager.shared_manager, :cache_data_cleared)
  end

  def numberOfSectionsInTableView tableView
    NUMBER_OF_SECTION
  end
  
  def tableView tableView, numberOfRowsInSection:section
    case section
    when INFO_SECTION
      @info_source.size
    when SETTING_SECTION
      2
    when COPYRIGHT_SECTION
      @copyright_source.size
    when VERSION_SECTION
      1
    else
      0
    end
  end

  VersionIdentifier = "VersionCell"
  LanguageIdentifier = "LanguageCell"
  ClearCacheIdentifier = "ClearCacheCell"
  CellIdentifier = "Cell"
  def tableView tableView, cellForRowAtIndexPath:indexPath
    case indexPath.section
    when SETTING_SECTION
      case indexPath.row
      when SETTING_ENGLISH_ROW
        identifier = LanguageIdentifier
      when SETTING_CLEAR_CACHE
        identifier = ClearCacheIdentifier
      end
    when VERSION_SECTION
      identifier = VersionIdentifier
    else
      identifier = CellIdentifier
    end
    cell = tableView.dequeueReusableCellWithIdentifier identifier, forIndexPath:indexPath
    
    case indexPath.section
    when INFO_SECTION
      cell.textLabel.text = @info_source[indexPath.row][:title]._
    when SETTING_SECTION
      case indexPath.row
      when SETTING_ENGLISH_ROW
        cell.textLabel.text = "English"._
        if cell.accessoryView.nil?
          s = UISwitch.new
          s.addTarget self, action:"didChangeEnglish:", forControlEvents:UIControlEventValueChanged
          cell.accessoryView = s
        end
        s.on = DataManager.shared_manager.english?
      when SETTING_CLEAR_CACHE
        cell.textLabel.text = "Clear cache data"._
        if cell.accessoryView.nil?
          s = UISwitch.new
          s.addTarget self, action:"didChangeClearCacheData:", forControlEvents:UIControlEventValueChanged
          cell.accessoryView = s
        end
      end
    when COPYRIGHT_SECTION
      cell.textLabel.text = @copyright_source[indexPath.row][:title]._
    when VERSION_SECTION
      cell.textLabel.text = "Version"._
      cell.detailTextLabel.text = "CFBundleVersion".info_plist
    end
    cell
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    cell = tableView.cellForRowAtIndexPath indexPath
    case indexPath.section
    when INFO_SECTION
      case cell.textLabel.text
      when "SUPPORT"._
        open_mail_form
        self.tableView.deselectRowAtIndexPath indexPath, animated:true
      else
        sb = UIStoryboard.storyboardWithName "Storyboard", bundle:nil
        c = sb.instantiateViewControllerWithIdentifier("WebViewController")
        c.url = NSURL.URLWithString @info_source[indexPath.row][:url]
        self.navigationController << c
      end
    when COPYRIGHT_SECTION
        sb = UIStoryboard.storyboardWithName "Storyboard", bundle:nil
        c = sb.instantiateViewControllerWithIdentifier("WebViewController")
        c.url = NSURL.URLWithString @copyright_source[indexPath.row][:url]
        self.navigationController << c
    end
  end


  def open_mail_form
    c = MFMailComposeViewController.new
    c.mailComposeDelegate = self
    c.setSubject "[iRubyKaigi'13]"
    c.setToRecipients ["support@itosoft.com"]
    c.modalTransitionStyle = UIModalTransitionStyleCoverVertical
    presentViewController c, animated:true, completion:nil
  end

  # MFMailComposeViewControllerDelegate
  def mailComposeController controller, didFinishWithResult:result, error:error
    case result
    when ::MFMailComposeResultCancelled, ::MFMailComposeResultSaved, ::MFMailComposeResultSent
      dismissViewControllerAnimated true, completion:nil
    end
  end
  
  def didChangeEnglish sender
    DataManager.shared_manager.english = sender.on?
  end
  
  def didChangeClearCacheData sender
    if sender.on?
      @data_clear_switch = sender
      SVProgressHUD.showWithStatus "Clearing ..."
      DataManager.shared_manager.begin_clear_cache_data
    end
  end


end
