require_relative 'version'

Pod::Spec.new do |s|
    s.name             = 'GravatarUI'
    s.version          = Gravatar::VERSION
    s.summary          = 'A convient library of Gravatar UI components'
  
    s.homepage         = 'https://gravatar.com'
    s.license          = { :type => 'Mozilla Public License v2', :file => 'LICENSE.md' }
    s.authors           = 'Automattic, Inc.'
    s.source           = {
        :git => 'https://github.com/Automattic/Gravatar-SDK-iOS.git',
        :tag => s.version.to_s
    }
    s.documentation_url = 'https://automattic.github.io/Gravatar-SDK-iOS/'
      
    s.swift_version     = '5.9'
    
    ios_deployment_target = '15.0'
    s.ios.deployment_target = ios_deployment_target

    s.source_files = 'Sources/GravatarUI/**/*.swift'
    s.resource_bundles = {
      'GravatarUI' => ['Sources/GravatarUI/Resources/*.xcassets']
    }
    s.dependency 'Gravatar', s.version.to_s
    s.ios.framework = 'UIKit'
  end
