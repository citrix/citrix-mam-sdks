Pod::Spec.new do |s|
	s.name             = 'CTXMAMNetwork'
    s.version          = '21.1.5'
    s.summary          = 'CTXMAMNetwork is responsible for tunneling network communication via SecureBrowse for applications which require tunneling functionality.'
    s.description      = <<-DESC
CTXMAMNetwork is responsible for tunneling network communication via SecureBrowse for applications which require tunneling functionality. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Citrix Systems, Inc.'
    s.module_name      = s.name
    s.requires_arc     = true
	s.license = {
		:text => "https://developer.cloud.com/citrix-api-terms-of-use",
		:type => "Custom"
	}
	s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CTXMAMNetwork/21.1.5/CTXMAMNetwork.zip' }
    s.source_files = 'CTXMAMNetwork/CTXMAMNetwork.framework/Headers/**/*.h'
    s.public_header_files = 'CTXMAMNetwork/CTXMAMNetwork.framework/Headers/**/*.h'
    s.vendored_frameworks = 'CTXMAMNetwork/CTXMAMNetwork.framework'

    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end
