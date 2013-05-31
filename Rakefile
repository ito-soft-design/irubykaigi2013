# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'rubygems'

require 'bundler'
Bundler.require

require 'sugarcube'
require 'sugarcube-anonymous'
require 'sugarcube-gestures'
require 'bubble-wrap'
require 'bubble-wrap/http'

version = '1.0.1'
adhoc = ARGV[0] == "archive"

Motion::Project::App.setup do |app|

  # Use `rake config' to see complete project settings.
  app.name = "iRubyKaigi'13"
  app.identifier = 'com.itosoft.irubykaigi.2013'

  app.device_family = [:iphone, :ipad]

  # frameworks
  app.frameworks += %w(MessageUI)

  app.pods do
    pod 'SVProgressHUD'
    pod 'CIALBrowser'
  end
  
  app.version = version
  app.info_plist['CFBundleShortVersionString'] = version
  app.deployment_target = '5.1'
  app.icons = ['icon-57x57@2x.png', 'icon-72x72@2x.png', 'icon-57x57.png', 'icon-72x72.png']
  app.prerendered_icon = true
  
  # Server
  app.info_plist['server'] = 'http://ayami.herokuapp.com'

  app.development do
    if adhoc
      # TODO: spcify your adhock provisioning files
      # app.codesign_certificate = "..."
      # app.provisioning_profile = "..."
    end
  end
  app.release do
    # TODO: spcify your appstore provisioning files
    # app.codesign_certificate = "..."
    # app.provisioning_profile = "..."
  end
  
  # Entitlements
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]
  app.development do
    app.entitlements['get-task-allow'] = false if adhoc
  end
end
