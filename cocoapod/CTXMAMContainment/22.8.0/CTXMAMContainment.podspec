Pod::Spec.new do |s|
    s.name             = 'CTXMAMContainment'
    s.version          = '22.8.0'
    s.summary          = 'CTXMAMContainment framework is responsible for controlling access to various device hardware features like cameras, microphones, and so on.'
    s.description      = <<-DESC
CTXMAMContainment framework is responsible for controlling access to various device hardware features like cameras, microphones, file system, and so on. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Citrix Systems, Inc.'
    s.platform         = :ios, "12.0"
    s.module_name      = s.name
    s.license = {
        :text => "https://developer.cloud.com/citrix-api-terms-of-use",
        :type => "Custom"
    }
    s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/main/cocoapod/CTXMAMContainment/22.8.0/CTXMAMContainment.zip' }
    s.source_files = 'CTXMAMContainment.xcframework/**/Headers/*.h'
    s.public_header_files = 'CTXMAMContainment.xcframework/**/Headers/*.h'
    s.vendored_frameworks = 'CTXMAMContainment.xcframework'

    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end
