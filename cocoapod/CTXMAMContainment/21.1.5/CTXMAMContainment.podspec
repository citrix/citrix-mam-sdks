Pod::Spec.new do |s|
	s.name             = 'CTXMAMContainment'
    s.version          = '21.1.5'
    s.summary          = 'CTXMAMContainment framework is responsible for controlling access to various device hardware features like cameras, microphones, file system, and so on.'
    s.description      = <<-DESC
CTXMAMContainment framework is responsible for controlling access to various device hardware features like cameras, microphones, file system, and so on. See https://developer.cloud.com/citrixworkspace/mobile-application-integration to learn more.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.author           = 'Citrix Systems, Inc.'
    s.module_name      = s.name
    s.requires_arc     = true
	s.license = {
		:text => "https://developer.cloud.com/citrix-api-terms-of-use",
		:type => "Custom"
	}
	s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CTXMAMContainment/21.1.5/CTXMAMContainment.zip' }
    s.source_files = 'CTXMAMContainment/CTXMAMContainment.framework/Headers/**/*.h'
    s.public_header_files = 'CTXMAMContainment/CTXMAMContainment.framework/Headers/**/*.h'
    s.vendored_frameworks = 'CTXMAMContainment/CTXMAMContainment.framework'

    s.dependency  'CTXMAMCore'
    s.dependency  'CitrixLogger'
end
