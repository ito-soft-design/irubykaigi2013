# -*- coding: utf-8 -*-
class HashModel

  def initialize h = {}
    @raw_data = h.to_object
  end
  
  def method_missing symbol, *args
    if args.size == 0
      key = symbol
      return @raw_data[key].to_object if @raw_data.include? key
      key = key.to_s
      return @raw_data[key].to_object if @raw_data.include? key
    end
    nil
  end
  
  def to_json
    BW::JSON.generate @raw_data
  end
  
end

