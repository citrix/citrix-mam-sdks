Pod::Spec.new do |s|
    s.name             = 'CTXMAMAppCore'
    s.version          = '22.8.0'
    s.summary          = 'CTXMAMAppCore SDK contains logic for any other common app functionality required by the remaining SDKs.'
    s.description      = <<-DESC
    CTXMAMAppCore SDK contains server data gathering logic, alerts, SDK mode control, and any other common functionality required by the remaining SDKs. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Citrix Systems, Inc.'
    s.module_name      = s.name
    s.platform         = :ios, "12.0"
    s.requires_arc     = true
    s.license = {
        :text => "https://developer.cloud.com/citrix-api-terms-of-use",
        :type => "Custom"
    }
    s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/main/cocoapod/CTXMAMAppCore/22.8.0/CTXMAMAppCore.zip' }
    s.source_files = 'CTXMAMAppCore.xcframework/**/Headers/*.h'
    s.public_header_files = 'CTXMAMAppCore.xcframework/**/Headers/*.h'
    s.vendored_frameworks = 'CTXMAMAppCore.xcframework'

    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end
