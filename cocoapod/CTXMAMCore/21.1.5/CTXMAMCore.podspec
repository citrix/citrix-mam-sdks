Pod::Spec.new do |s|
    s.name         = 'CTXMAMCore'
    s.version      = '21.1.5'
    s.summary      = 'This pod provides the core functionality for the Citrix MAM SDK.'
    s.description  = <<-DESC
    This pod provides the core functionality for the Citrix MAM SDK
    DESC
    s.homepage     = 'https://github.com/citrix/citrix-mam-sdks'
    s.license = { :type => "Copyright (c) 2021 Citrix Systems, Inc. All rights reserved.",
        :text => "Custom"
    }
 
    s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CTXMAMCore/21.1.5/CTXMAMCore.zip' }
    
    s.ios.deployment_target = '10.0'
    
    s.ios.source_files = [
        'CTXMAMCore/CTXMAMCore.framework/Headers/**/*.h'
    ]
    
    s.ios.public_header_files = 'CTXMAMCore/CTXMAMCore.framework/Headers/**/*.h'
    
    s.ios.vendored_frameworks = 'CTXMAMCore/CTXMAMCore.framework'
    
    s.dependency  'CitrixLoggerDynamicFramework'

end