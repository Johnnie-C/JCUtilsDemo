Pod::Spec.new do |spec|
    spec.name         = 'JCFramework'
    spec.version      = '1.0.0'
    spec.license      = { :type => 'BSD' }
    spec.homepage     = 'https://github.com/EzlyJohnnie/JCUtilsDemo'
    spec.authors      = { 'Johnnie Cheng' => 'a81658804@hotmail.com' }
    spec.summary      = 'Common utils, helper and demos.'
    #spec.source       = { :path => '../JCFramework/' }
    spec.source       = { :podspec => 'https://raw.githubusercontent.com/EzlyJohnnie/JCUtilsDemo/master/JCFramework/JCFramework.podspec' }
    spec.source_files = '../JCFramework/**/*.{h,m}'
    spec.resources    = [ '../JCFramework/**/*.xib', '..JCFramework/Resource/**/*.*']
    spec.framework    = 'SystemConfiguration'
    spec.ios.deployment_target  = '9.0'
end
