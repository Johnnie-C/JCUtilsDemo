Pod::Spec.new do |spec|
    spec.name         = 'JCFloatingView'
    spec.version      = '1.0.0'
    spec.license      = { :type => 'BSD' }
    spec.homepage     = 'https://github.com/EzlyJohnnie/JCUtilsDemo/tree/master/JCFloatingView'
    spec.authors      = { 'Johnnie Cheng' => 'a81658804@hotmail.com' }
    spec.summary      = 'App level floating view.'
    spec.source       = { :git => "https://github.com/EzlyJohnnie/JCUtilsDemo.git" }
    spec.source_files = '**/*.{h,m,xib}'
    spec.resources = ['JCFloatingView/Resources/**/*.*', 'JCFramework/Resources/**/*.*']
    spec.exclude_files = [ 'JCFrameworkDemo/**' ]
    spec.framework    = 'SystemConfiguration'
end
