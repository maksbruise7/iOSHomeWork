platform :ios, '16.0'

target 'Navigation' do
  use_frameworks!
  
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'SnapKit', '~> 5.6.0'
end

target 'StorageService' do
  use_frameworks!
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
    end
  end
end