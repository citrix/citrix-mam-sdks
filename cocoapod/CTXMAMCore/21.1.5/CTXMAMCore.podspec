Pod::Spec.new do |s|
    s.name         = 'CTXMAMCore'
    s.version      = '21.1.5'
    s.summary      = 'This pod provides the core functionality for the Citrix MAM SDK.'
    s.author       = 'Citrix Systems, Inc.'
    s.description  = <<-DESC
This pod provides the core functionality for the Citrix MAM SDK. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
    DESC
    s.homepage     = 'https://github.com/citrix/citrix-mam-sdks'
    s.ios.deployment_target = '10.0'
    s.license = {
        :type => "https://developer.cloud.com/citrix-api-terms-of-use",
        :text => "Custom"
    }
    s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CTXMAMCore/21.1.5/CTXMAMCore.zip' }
    s.source_files = 'CTXMAMCore/CTXMAMCore.framework/Headers/**/*.h'
    s.public_header_files = 'CTXMAMCore/CTXMAMCore.framework/Headers/**/*.h'
    s.vendored_frameworks = 'CTXMAMCore/CTXMAMCore.framework'

    s.dependency  'CitrixLogger'
end
