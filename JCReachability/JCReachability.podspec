Pod::Spec.new do |spec|
    spec.name         = 'JCReachability'
    spec.version      = '1.0.0'
    spec.license      = { :type => 'BSD' }
    spec.homepage     = 'https://github.com/EzlyJohnnie/JCUtilsDemo'
    spec.authors      = { 'Johnnie Cheng' => 'a81658804@hotmail.com' }
    spec.summary      = 'Reachability check'
    spec.source       = { :path => '../JCReachability/' }
    spec.source_files = '../JCReachability/**/*.{h,m}'
    spec.framework    = 'SystemConfiguration'
    spec.ios.deployment_target  = '9.0'
    spec.dependency 'JCFramework'
end
