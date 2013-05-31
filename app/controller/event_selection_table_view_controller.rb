# -*- coding: utf-8 -*-
class EventSelectionTableViewController < UITableViewController

  def viewDidLoad
    super
    navigationItem.leftBarButtonItem = UIBarButtonItem.titled('Close'._) do
      self.dismissViewControllerAnimated(true, completion:nil)
    end
    
    @events = [[], []]
    @manager = DataManager.shared_manager
    @manager.events.each do |e|
      @events[e.past? ? 1 : 0] << e
    end
    @events[0] = @events[0].sort_by{|e| e.start_at}
    @events[1] = @events[1].sort_by{|e| e.end_at}.reverse
  end

  def numberOfSectionsInTableView tableView
    @events.size
  end
  
  def tableView tableView, numberOfRowsInSection:section
    @events[section].size
  end

  def tableView tableView, titleForHeaderInSection:section
    case section
    when 0
      @events[section].size == 0 ? nil : "Up-comming"._
    when 1
      @events[section].size == 0 ? nil : "Past"._
    end
  end

  def tableView tableView, heightForRowAtIndexPath:indexPath
    60
  end

  CellIdentifier = "Cell"
  def tableView tableView, cellForRowAtIndexPath:indexPath
    cell = tableView.dequeueReusableCellWithIdentifier CellIdentifier
    cell ||= UITableViewCell.alloc.initWithStyle UITableViewCellStyleSubtitle, reuseIdentifier:CellIdentifier
    event = @events[indexPath.section][indexPath.row]
    cell.textLabel.text = event.title
    if event.days == 1
      cell.detailTextLabel.text = event.start_at.string_with_style(:short)
    else
      cell.detailTextLabel.text = event.start_at.string_with_style(:short) + " - " + event.end_at.string_with_style(:short)
    end
    cell.accessoryType = @manager.current_event == event ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone
    cell
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    event = @events[indexPath.section][indexPath.row]
    @manager.current_event = event
    close self
  end
  
  def close sender
    dismissViewControllerAnimated true, completion:nil
  end


end
