Pod::Spec.new do |s|
	s.name             = 'CitrixLogger'
    s.version          = '21.1.5'
    s.summary          = 'CitrixLogger framework is used for log creation, log collection, log packaging and log dispatch.'
    s.description      = <<-DESC
CitrixLogger framework is used for log creation, log collection, log packaging and log dispatch.
                       DESC
    s.homepage         = 'https://github.com/citrix/citrix-mam-sdks'
    s.module_name = s.name
    s.platform = :ios, "8.0"
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
	s.license = {
		:text => "https://developer.cloud.com/citrix-api-terms-of-use",
		:type => "Custom"
	}

	s.source = { :http => 'https://raw.githubusercontent.com/citrix/citrix-mam-sdks/develop/cocoapod/CitrixLogger/21.1.5/CitrixLogger.zip' }

    s.source_files = [
        'CitrixLogger/CitrixLogger.framework/Headers/**/*.h'
    ]

    s.public_header_files = [
        'CitrixLogger/CitrixLogger.framework/Headers/**/*.h'
    ]

    s.vendored_frameworks = [
        'CitrixLogger/CitrixLogger.framework'
    ]

end
