Pod::Spec.new do |spec|
    spec.name         = 'JCFloatingView'
    spec.version      = '1.0.0'
    spec.license      = { :type => 'BSD' }
    spec.homepage     = 'https://github.com/EzlyJohnnie/JCUtilsDemo/tree/master/JCFloatingView'
    spec.authors      = { 'Johnnie Cheng' => 'a81658804@hotmail.com' }
    spec.summary      = 'App level floating view.'
    spec.source       = { :git => "https://github.com/EzlyJohnnie/JCUtilsDemo.git" }
    spec.exclude_files = [ 'JCFrameworkDemo/**/*.*' ]
    spec.framework    = 'SystemConfiguration'
    spec.ios.deployment_target  = '9.0'
    
    s.subspec 'JCFramework' do |sub|
		sub.source_files = 'JCFramework/**/*.{h,m}'
		sub.resources = [ 'JCFramework/**/*.xib', 'JCFramework/Resource/**/*.*']
		sub.public_header_files = 'JCFramework/**/*.h'
	end
	
	s.subspec 'JCFloatingView' do |sub|
		sub.source_files = 'JCFloatingView/**/*.{h,m}'
		sub.resources = [ 'JCFloatingView/**/*.xib', 'JCFloatingView/Resource/**/*.*']
		sub.public_header_files = 'JCFloatingView/**/*.h'
		sub.dependency 'JCFloatingView/JCFramework'
	end
	
end
