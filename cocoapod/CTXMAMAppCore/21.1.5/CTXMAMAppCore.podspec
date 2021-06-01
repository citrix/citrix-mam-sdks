Pod::Spec.new do |s|
	s.name             = 'CTXMAMAppCore'
    s.version          = '21.1.5'
    s.summary          = 'CTXMAMAppCore SDK contains server data getching logic, alerts, SDK mode control, and any other common functionality required by the remaining SDKs.'
    s.description      = <<-DESC
    CTXMAMAppCore SDK contains server data getching logic, alerts, SDK mode control, and any other common functionality required by the remaining SDKs. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Citrix Systems, Inc.'
    s.module_name      = s.name
    s.requires_arc     = true
	s.license = {
		:text => "https://developer.cloud.com/citrix-api-terms-of-use",
		:type => "Custom"
	}
	s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CTXMAMAppCore/21.1.5/CTXMAMAppCore.zip' }
    s.source_files = 'CTXMAMAppCore/CTXMAMAppCore.framework/Headers/**/*.h'
    s.public_header_files = 'CTXMAMAppCore/CTXMAMAppCore.framework/Headers/**/*.h'
    s.vendored_frameworks = 'CTXMAMAppCore/CTXMAMAppCore.framework'

    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end
