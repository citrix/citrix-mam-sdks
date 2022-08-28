Pod::Spec.new do |s|
    s.name         = 'CTXMAMCore'
    s.version      = '22.8.0'
    s.summary      = 'This pod provides the core functionality for the Citrix MAM SDK.'
    s.author       = 'Citrix Systems, Inc.'
    s.description  = <<-DESC
This pod provides the core functionality for the Citrix MAM SDK. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
    DESC
    s.homepage     = 'https://github.com/citrix/citrix-mam-sdks'
    s.platform     = :ios, '12.0'
    s.license = {
        :type => "https://developer.cloud.com/citrix-api-terms-of-use",
        :text => "Custom"
    }
    s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/main/cocoapod/CTXMAMCore/22.8.0/CTXMAMCore.zip' }
    s.source_files = 'CTXMAMCore.xcframework/**/Headers/*.h'
    s.public_header_files = 'CTXMAMCore.xcframework/**/Headers/*.h'
    s.vendored_frameworks = 'CTXMAMCore.xcframework'

    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    s.dependency  'CitrixLogger'
end
