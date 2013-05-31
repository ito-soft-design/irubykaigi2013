# -*- coding: utf-8 -*-
class EventDetailTableViewController < UITableViewController

  attr_accessor :event

  TimeSpanSection   = 0
  TitleSection      = 1
  PresenterSection  = 2
  LanguageSection   = 3
  AbstractSection   = 4
  RoomSection       = 5
  ArchivesSection   = 6
  

  def numberOfSectionsInTableView tableView
    7
  end
  
  def tableView tableView, numberOfRowsInSection:section
    case section
    when PresenterSection
      event.presenters.size
    when ArchivesSection
      event.archives.size
    else
      tableView(tableView, titleForHeaderInSection:section).blank? ? 0 : 1
    end
  end

  def tableView tableView, titleForHeaderInSection:section
    title = %w(Time Title Presenter(s) Language Abstract Room Archives)[section]._
    case section
    when TimeSpanSection
      event.timespan.blank? ? nil : title
    when TitleSection
      event.title.blank? ? nil : title
    when PresenterSection
      event.presenters.size == 0 ? nil : title
    when LanguageSection
      event.language.blank? ? nil : title
    when AbstractSection
      event.abstract.blank? ? nil : title
    when RoomSection
      event.room.name.blank? ? nil : title
    when ArchivesSection
      event.archives.size == 0 ? nil : title
    end
  end

  CellIdentifier = "Cell"
  def tableView tableView, cellForRowAtIndexPath:indexPath
    identifier = %w(Cell Cell Cell Cell Cell Cell Cell)[indexPath.row]
    cell = tableView.dequeueReusableCellWithIdentifier identifier, forIndexPath:indexPath
    case indexPath.section
    when TimeSpanSection
      cell.textLabel.text = event.timespan
    when TitleSection
      cell.textLabel.text = event.title
    when PresenterSection
      cell.textLabel.text = event.presenters[indexPath.row].name
    when LanguageSection
      cell.textLabel.text = event.language
    when AbstractSection
      cell.textLabel.text = event.abstract
    when RoomSection
      cell.textLabel.text = event.room.name
    when ArchivesSection
      cell.textLabel.text = event.archives[indexPath.row].title
    end
    
    case indexPath.section
    when PresenterSection
    when ArchivesSection
      cell.selectionStyle = UITableViewCellSelectionStyleBlue
    else
      cell.selectionStyle = UITableViewCellSelectionStyleNone
    end
    
    cell
  end

end
