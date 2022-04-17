# Uncomment this line to define a global platform for your project
platform :ios, '10.0'
source 'https://cdn.cocoapods.org/'
source 'https://github.com/lfsluoye/CCRepo.git'

use_frameworks!

target 'CCNetwork' do
  pod 'HandyJSON'
  pod 'Moya'
#  pod 'CCNetwork', :path=>'./'
 
end
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
