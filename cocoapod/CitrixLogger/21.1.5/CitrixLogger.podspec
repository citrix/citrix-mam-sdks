Pod::Spec.new do |s|
	s.name             = 'CitrixLogger'
    s.version          = '21.1.5'
    s.summary          = 'CitrixLogger framework is used for log creation, log collection, log packaging and log dispatch.'
    s.description      = <<-DESC
CitrixLogger framework is used for log creation, log collection, log packaging and log dispatch. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.module_name      = s.name
    s.author           = 'Citrix Systems, Inc.'
    s.platform         = :ios, "8.0"
    s.requires_arc     = true
    s.ios.deployment_target = '8.0'
	s.license = {
		:text => "https://developer.cloud.com/citrix-api-terms-of-use",
		:type => "Custom"
	}
	s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CitrixLogger/21.1.5/CitrixLogger.zip' }
    s.vendored_frameworks = 'CitrixLogger/CitrixLogger.framework'
end
