Pod::Spec.new do |s|
    s.name             = 'CTXMAMLocalAuth'
    s.version          = '23.10.0'
    s.summary          = 'CTXMAMLocalAuth is responsible for enforcing device passcode and max offline periods.'
    s.description      = <<-DESC
CTXMAMLocalAuth is responsible for enforcing device passcode and max offline periods. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Cloud Software Group, Inc.'
    s.module_name      = s.name
    s.platform         = :ios, "12.0"
    s.license = {
        :text => "https://developer.cloud.com/citrix-api-terms-of-use",
        :type => "Custom"
    }
    s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/main/cocoapod/CTXMAMLocalAuth/23.10.0/CTXMAMLocalAuth.zip' }
    s.source_files = 'CTXMAMLocalAuth.xcframework/**/Headers/*.h'
    s.public_header_files = 'CTXMAMLocalAuth.xcframework/**/Headers/*.h'
    s.vendored_frameworks = 'CTXMAMLocalAuth.xcframework'

    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }


    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end
