# -*- coding: utf-8 -*-
class DataManager

  attr_accessor :json_data, :speakers, :events, :current_event
  attr_accessor :cache_data_cleared
  
  def english?
    v = NSUserDefaults["english"]
    v.nil? ? current_language? != "ja" : v
  end

  def english= english
    willChangeValueForKey "english"
    NSUserDefaults["english"] = english
    didChangeValueForKey "english"
  end
  
  def current_language?
    @current_language || NSLocale.preferredLanguages[0]
  end
  
  def self.shared_manager
    @@shared_manager ||= self.new
  end

  def begin_load_events
    url = "#{server}/events.json"
    BW::HTTP.get(url, { :format => :json }) do |response|
      if response.ok?
        begin
          data = response.body
          new_events = Event.parse(data.to_str)
          
          # 日付が更新されているか確認する
          changed = self.events.blank?  # 未登録か確認
          # 新たなイベントが追加された場合
          changed = true unless (new_events.map{|e| e.id} - self.events.map{|e| e.id}).size == 0
          begin
            new_events.each do |e|
              self.events.each do |oe|
                if e.id == oe.id
                  unless e.updated_at == oe.updated_at
                    changed = true
                    break
                  end
                end
                break if changed
              end
            end unless changed
          rescue => e
            changed = true
          end unless changed
          # 更新されていたら保存する
          if changed
            data.write_to path_for_events
          else
            new_events = nil
          end
        rescue
          new_events = nil
        end
        # パースが失敗したり更新されていない場合は現状のまま
        self.events = new_events if new_events
      elsif response.status_code.to_s =~ /40\d/
#        App.alert("Login failed")
      else
#        App.alert(response.error_message)
      end
    end
  end

  def path_for_events
    path = "events".cache
    unless path.exists?
      NSFileManager.defaultManager.createDirectoryAtPath path, withIntermediateDirectories:true, attributes:nil, error:nil
    end
    File.join(path, "events.json")
  end

  def begin_clear_cache_data
    gcdq = Dispatch::Queue.concurrent
    gcdq.async {
      self.cache_data_cleared = false
      @path = "avatar".cache
      m = NSFileManager.defaultManager
      m.removeItemAtPath @path, error:nil
      Dispatch::Queue.main.async{
        self.cache_data_cleared = true
      }
    }
  end

  def current_event
    @current_event ||= begin
      event_id = NSUserDefaults["current_event_id"]
      e = events.find{|e| e.id == event_id} if event_id
      e = events.find{|e| e.title == "RubyKaigi 2013"} unless e
      e = events.first unless e
      e
    end
  end

  def current_event= event
    willChangeValueForKey "current_event"
    @current_event = event
    NSUserDefaults["current_event_id"] = @current_event.id
    didChangeValueForKey "current_event"
  end

  def events
    @events ||= begin
      Event.parse path_for_events.fileurl.nsdata
    rescue
      Event.parse "events.json".resource_url.nsdata
    end
  end

  def events= events
    willChangeValueForKey "events"
    @current_event = nil
    @events = events
    didChangeValueForKey "events"
  end

  def english
    true
  end

  def favorit_dict
    @favorit_dict ||= begin
      h = {}
      begin
        h = BW::JSON.parse "favorits.json".cache.fileurl.nsdata.nsstring
      rescue
      end
      h
    end
  end

  def server
    "server".info_plist
  end

  def grouped_speakers
    @sorted_speakers ||= begin
      h = {}
      speakers.keys.sort.each do |name|
        l = name[0].upcase
        unless /[A-Z]/ =~ l
          l = "etc"
        end
        a = h[l]
        unless a
          a = []
          h[l] = a
        end
        a << Speaker.new(name:name, events:speakers[name])
      end
      h
    end
  end

  def cache_data_cleared= cleard
    willChangeValueForKey "cache_data_cleared"
    @cache_data_cleared = cleard
    didChangeValueForKey "cache_data_cleared"
  end


end

# 循環参照になるのでここに置く
class HashModel

  def english?
    DataManager.shared_manager.english?
  end
  
end


def date_from_yyyy_mm_dd str, timezone = nil
  timezone ||= NSTimeZone.timeZoneForSecondsFromGMT(9 * 60 * 60)
  a = str.split("-")
  NSDate.from_components(year:a[0], month:a[1], day:a[2], timeZone:timezone)
end

def date_string date, format = nil
  format ||= DataManager.shared_manager.english ? "MMMM d" : "M月d日"
  f = NSDateFormatter.new
  f.setDateFormat format
  f.stringFromDate date
end
