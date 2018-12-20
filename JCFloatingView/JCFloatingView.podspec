Pod::Spec.new do |spec|
    spec.name         = 'JCFloatingView'
    spec.version      = '1.0.0'
    spec.license      = { :type => 'BSD' }
    spec.homepage     = 'https://github.com/EzlyJohnnie/JCUtilsDemo'
    spec.authors      = { 'Johnnie Cheng' => 'a81658804@hotmail.com' }
    spec.summary      = 'App level floating view.'
    # spec.source       = { :path => '../JCFloatingView/' }
    spec.source       = { :podspec => 'https://raw.githubusercontent.com/EzlyJohnnie/JCUtilsDemo/master/JCFloatingView/JCFloatingView.podspec' }
    spec.source_files = '../JCFloatingView/**/*.{h,m}'
    spec.resources    = [ '../JCFloatingView/**/*.xib', '../JCFloatingView/Resources/**/*.*' ]
    spec.framework    = 'SystemConfiguration'
    spec.ios.deployment_target  = '9.0'
    spec.dependency 'JCFramework' :podspec => 'https://raw.githubusercontent.com/EzlyJohnnie/JCUtilsDemo/master/JCFramework/JCFramework.podspec'
    
    #spec.subspec 'JCFramework' do |ss|
    #   ss.source_files         = '../JCFramework/**/*.{h,m,xib}'
    #    ss.resource             = '../JCFramework/**/Resource/*.*'
    #end
end
