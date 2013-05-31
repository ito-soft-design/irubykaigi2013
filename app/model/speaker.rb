# -*- coding: utf-8 -*-
class Speaker < HashModel
  include BW::KVO
  
  attr_accessor :icon, :session
  
  def initialize h
    super
    m = DataManager.shared_manager
    observe(m, :cache_data_cleared) do |old_value, new_value|
      self.icon = nil if new_value
    end
  end
  
  def dealloc
    m = DataManager.shared_manager
    unobserve(m, :cache_data_cleared)
  end
  
  def name
    english? ? name_en : @raw_data.name
  end

  def abstract
    english? ? abstract_en : @raw_data.abstract
  end

  def socials
    @socials ||= begin
      h = {}
      @raw_data.socials.each do |s|
        h[s.social_name] = s
      end
      h
    end
  end
  
  def thumb_icon
    return nil if self.icon.nil?
    @thumb_icon ||= self.icon.scale_to(CGSizeMake(60,60))
  end
  
  def organizations
    @organizations ||= begin
      a = @raw_data.organizations.each do |o|
        Organization.new o
      end
      a.to_object
    end
  end
  
  def twitter
    s = self.socials["Twitter"]
    s ? "@#{s.user_name}" : nil
  end
  
  def github
    s = self.socials["Github"]
    s ? s.user_name : nil
  end
  
  def gravatar
    s = self.socials["Gravatar"]
    s ? s.avatar : nil
  end
  
  def begin_load_icon
    if self.gravatar
      @path = "avatar".cache
      m = NSFileManager.defaultManager
      m.createDirectoryAtPath @path, withIntermediateDirectories:true, attributes:nil, error:nil
      @path = File.join(@path, self.gravatar + ".png")
      
      if @path.exists?
        data = @path.fileurl.nsdata
        self.icon = data.uiimage
      else
        BW::HTTP.get("http://www.gravatar.com/avatar/#{self.gravatar}?s=200&d=404") do |response|
          if response.ok?
            data = response.body
            data.write_to @path
            self.icon = data.uiimage
          else
            self.icon = nil
          end
        end
      end
    end
  end
  
end
