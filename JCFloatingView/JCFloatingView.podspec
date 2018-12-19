Pod::Spec.new do |spec|
    spec.name         = 'JCFloatingView'
    spec.version      = '1.0.0'
    spec.license      = { :type => 'BSD' }
    spec.homepage     = 'https://github.com/EzlyJohnnie/JCUtilsDemo'
    spec.authors      = { 'Johnnie Cheng' => 'a81658804@hotmail.com' }
    spec.summary      = 'App level floating view.'
    spec.source       = { :path => '../JCFloatingView/' }
    spec.source_files = '*.{h,m,xib}'
    spec.framework    = 'SystemConfiguration'
    spec.dependency'JCFramework'

    spec.subspec 'JCFramework' do |ss|
        ss.source_files         = '../JCFramework/**/*.{h,m,xib}'
        ss.resource              = '../JCFramework/**/Resource/*.*'
    end
end
