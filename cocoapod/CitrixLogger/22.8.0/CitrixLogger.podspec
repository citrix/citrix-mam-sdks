Pod::Spec.new do |s|
    s.name             = 'CitrixLogger'
    s.version          = '22.8.0'
    s.summary          = 'CitrixLogger framework is used for log creation, log collection, log packaging and log dispatch.'
    s.description      = <<-DESC
CitrixLogger framework is used for log creation, log collection, log packaging and log dispatch. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.module_name      = s.name
    s.author           = 'Citrix Systems, Inc.'
    s.platform         = :ios, "12.0"
    s.requires_arc     = true
    s.license = {
        :text => "https://developer.cloud.com/citrix-api-terms-of-use",
        :type => "Custom"
    }
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/main/cocoapod/CitrixLogger/22.8.0/CitrixLogger.zip' }
    s.vendored_frameworks = 'CitrixLogger.xcframework'
end
