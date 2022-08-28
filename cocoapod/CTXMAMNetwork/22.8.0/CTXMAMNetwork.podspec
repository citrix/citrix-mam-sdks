Pod::Spec.new do |s|
    s.name             = 'CTXMAMNetwork'
    s.version          = '22.8.0'
    s.summary          = 'CTXMAMNetwork is responsible for tunneling network communication via SecureBrowse for applications which require tunneling functionality.'
    s.description      = <<-DESC
CTXMAMNetwork is responsible for tunneling network communication via SecureBrowse for applications which require tunneling functionality. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Citrix Systems, Inc.'
    s.module_name      = s.name
    s.platform         = :ios, "12.0"
    s.license = {
        :text => "https://developer.cloud.com/citrix-api-terms-of-use",
        :type => "Custom"
    }
    s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/main/cocoapod/CTXMAMNetwork/22.8.0/CTXMAMNetwork.zip' }
    s.source_files = 'CTXMAMNetwork.xcframework/**/Headers/*.h'
    s.public_header_files = 'CTXMAMNetwork.xcframework/**/Headers/*.h'
    s.vendored_frameworks = 'CTXMAMNetwork.xcframework'

    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end
