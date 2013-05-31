# -*- coding: utf-8 -*-
class Organization < HashModel

  def name
    english? ? name_en : @raw_data.name
  end

end
