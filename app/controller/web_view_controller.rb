# -*- coding: utf-8 -*-
class WebViewController < UIViewController

  attr_accessor :webView #@type_info UIWebView
  attr_accessor :url

  def blank_url
    "blank.html".resource_url
  end
  

  def viewDidLoad
    super
    @loading_blank = true
    self.webView.loadRequest NSURLRequest.requestWithURL(self.blank_url)
  end

  def viewWillDisappear animated
    super
    self.webView
  end
  
  def webViewDidStartLoad webView
  end

  def webViewDidFinishLoad webView
    self.webView.loadRequest NSURLRequest.requestWithURL(self.url) if @loading_blank
    @loading_blank = false
  end

  def webView webView, didFailLoadWithError:error
    s = "<html><center><font size=+5 color='red'>" + "Failed to load!<br />Please check network settings.<br />Back and try again!"._ + "</font></center></html>"
    webView.loadHTMLString s, baseURL:nil
  end

  def itunes_store_url? url
    app_store_url = 'http://phobos.apple.com/WebObjects/'
    return true if url.absoluteString[0, app_store_url.length - 1] == app_store_url
    url.host == 'itunes.apple.com'
  end
                                                          
  def webView webView, shouldStartLoadWithRequest:request, navigationType:navigationType
    url = request.URL
    if itunes_store_url?(url) || %w(http https file).include?(url.scheme) == false
      webView.stopLoading
      app = UIApplication.sharedApplication
      if app.canOpenURL url
        app.openURL url
        return false
      end
    end
    true
  end

end
