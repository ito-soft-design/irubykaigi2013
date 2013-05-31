# -*- coding: utf-8 -*-
class Session < HashModel

  attr_accessor :time_slot, :session
  
  def speakers
    @speakers ||= begin
      a = []
      @raw_data.speakers.each do |s|
        speaker = Speaker.new s
        speaker.session = self
        a << speaker
      end
      a.to_object
    end
  end
  
  def sessions
    @sessions ||= begin
      a = []
      @raw_data.sessions.each do |s|
        session = Session.new s
        session.session = self
        a << session
      end
      a.to_object
    end
  end
  
  def time_slot
    return @time_slot if @time_slot
    return session.time_slot if session
    nil
  end
  
  
  def tint_color
    case self.kind
    when "session"
      :white.uicolor
    else
      "#fff2f7".uicolor
    end
  end

  def title
    english? ? title_en : @raw_data.title
  end

  def abstract
    english? ? abstract_en : @raw_data.abstract
  end

end
