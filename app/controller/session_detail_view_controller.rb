# -*- coding: utf-8 -*-
class SessionDetailViewController < UIViewController

  attr_accessor :session
  attr_accessor :sessionView # @type_info SessionDetailBaseView

  def dealloc
    session = nil
    sessionView.clean
  end

  def viewWillDisappear animated
    super
    session = nil
  end
  
# DELETEME:
  def session= session
    @session = session
  end

end
