Pod::Spec.new do |s|
	s.name             = 'CTXMAMLocalAuth'
    s.version          = '21.1.5'
    s.summary          = 'CTXMAMLocalAuth is responsible for enforcing device passcode and max offline periods.'
    s.description      = <<-DESC
CTXMAMLocalAuth is responsible for enforcing device passcode and max offline periods. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Citrix Systems, Inc.'
    s.module_name      = s.name
    s.requires_arc     = true
	s.license = {
		:text => "https://developer.cloud.com/citrix-api-terms-of-use",
		:type => "Custom"
	}
	s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CTXMAMLocalAuth/21.1.5/CTXMAMLocalAuth.zip' }
    s.source_files = 'CTXMAMLocalAuth/CTXMAMLocalAuth.framework/Headers/**/*.h'
    s.public_header_files = 'CTXMAMLocalAuth/CTXMAMLocalAuth.framework/Headers/**/*.h'
    s.vendored_frameworks = 'CTXMAMLocalAuth/CTXMAMLocalAuth.framework'

    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end