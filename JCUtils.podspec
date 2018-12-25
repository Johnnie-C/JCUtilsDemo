Pod::Spec.new do |spec|
    spec.name         = 'JCUtils'
    spec.version      = '1.0.0'
    spec.license      = { :type => 'BSD' }
    spec.homepage     = 'https://github.com/EzlyJohnnie/JCUtilsDemo/tree/master/JCFloatingView'
    spec.authors      = { 'Johnnie Cheng' => 'a81658804@hotmail.com' }
    spec.summary      = 'App level floating view.'
    spec.source       = { :git => "https://github.com/EzlyJohnnie/JCUtilsDemo.git", :branch => 'feature/restructure' }
    spec.exclude_files = [ 'JCFrameworkDemo/**/*.*' ]
    spec.framework    = 'SystemConfiguration'
    spec.ios.deployment_target  = '9.0'
    
    spec.subspec 'JCFramework' do |sub|
        sub.source_files = 'JCFramework/**/*.{h,m}'
        sub.resources = [ 'JCFramework/**/*.xib', 'JCFramework/Resource/**/*.*']
        sub.public_header_files = 'JCFramework/**/*.h'
        sub.dependency 'SAMKeychain'
    end


    spec.subspec 'JCFrameworkEssential' do |sub|
        sub.source_files = [ 'JCFramework/JCFramework/JCFramework.h', 'JCFramework/JCFramework/Essential/**/*.{h,m}' ]
        sub.public_header_files = 'JCFramework/JCFramework/Essential/**/*.h'
    end


    spec.subspec 'JCDesign' do |sub|
        sub.source_files = [ 'JCFramework/JCFramework/Design/**/*.{h,m}' ]
        sub.resources = [ 'JCFramework/**/*.xib', 'JCFramework/Resource/**/*.*']
        sub.public_header_files = 'JCFramework/JCFramework/Design/**/*.h'
        sub.dependency 'JCUtils/JCFrameworkEssential'
    end


    spec.subspec 'JCAuthentication' do |sub|
        sub.source_files = [ 'JCFramework/JCFramework/JCHelpers/Authentication/**/*.{h,m}' ]
        sub.public_header_files = 'JCFramework/JCFramework/JCHelpers/Authentication/**/*.h'
        sub.resources = [ 'JCFramework/JCFramework/JCHelpers/Authentication/**/*.{xib,png}']
        sub.dependency 'JCUtils/JCFrameworkEssential'
        sub.dependency 'SAMKeychain'
    end


    spec.subspec 'JCLocation' do |sub|
        sub.source_files = [ 'JCFramework/JCFramework/JCHelpers/Location/**/*.{h,m}' ]
        sub.public_header_files = 'JCFramework/JCFramework/JCHelpers/Location/**/*.h'
        sub.dependency 'JCUtils/JCFrameworkEssential'
    end

    spec.subspec 'JCAlert' do |sub|
        sub.source_files = [ 'JCFramework/JCFramework/JCAlert/*.{h,m}' ]
        sub.public_header_files = 'JCFramework/JCFramework/JCAlert/*.h'
        sub.dependency 'JCUtils/JCFrameworkEssential'
    end


    spec.subspec 'JCToast' do |sub|
        sub.source_files = [ 'JCFramework/CRToast/*.{h,m}' ]
        sub.public_header_files = 'JCFramework/CRToast/*.h'
        sub.dependency 'JCUtils/JCFrameworkEssential'
    end


    spec.subspec 'JCViewTouchHighlighting' do |sub|
        sub.source_files = [ 'JCFramework/UIView+TouchHighlighting/**/*.{h,m}' ]
        sub.public_header_files = 'JCFramework/UIView+TouchHighlighting/**/*.h'
    end


    spec.subspec 'JCFloatingView' do |sub|
        sub.source_files = 'JCFloatingView/**/*.{h,m}'
        sub.resources = [ 'JCFloatingView/**/*.xib', 'JCFloatingView/Resources/**/*.*']
        sub.public_header_files = 'JCFloatingView/**/*.h'
        sub.dependency 'JCUtils/JCFrameworkEssential'
    end
	
end
