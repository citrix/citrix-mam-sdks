Pod::Spec.new do |s|
	s.name             = 'CTXMAMCompliance'
    s.version          = '21.1.5'
    s.summary          = 'CTXMAMCompliance is responsible for ensuring that the device is compliant with the company policy.'
    s.description      = <<-DESC
CTXMAMCompliance is responsible for ensuring that the device is compliant with the company policy, for example checking if the device is configured with a passcode or if the device is jailbroken. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Citrix Systems, Inc.'
    s.module_name      = s.name
    s.requires_arc     = true
	s.license = {
		:text => "https://developer.cloud.com/citrix-api-terms-of-use",
		:type => "Custom"
	}
	s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CTXMAMCompliance/21.1.5/CTXMAMCompliance.zip' }
    s.source_files = 'CTXMAMCompliance/CTXMAMCompliance.framework/Headers/**/*.h'
    s.public_header_files = 'CTXMAMCompliance/CTXMAMCompliance.framework/Headers/**/*.h'
    s.vendored_frameworks = 'CTXMAMCompliance/CTXMAMCompliance.framework'

    s.dependency  'CTXMAMAppCore'
    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end