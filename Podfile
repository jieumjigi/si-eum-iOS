# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

def shared_pods
  use_frameworks!
  pod 'SnapKit', '~> 4.0.0'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'DBImageColorPicker', '~> 1.0.0'
  pod 'Alamofire', '~> 4.3'
  pod 'SwiftyBeaver'
  pod 'PopupDialog', '~> 0.5'
  pod 'SwiftyJSON'
  pod 'Kingfisher', '~> 4.0'
  pod 'SHSideMenu', '~> 0.0.4' 
  pod 'RxDataSources', '~> 3.0'
  pod 'RxTheme'
  pod 'Then'
  pod 'ObjectMapper', '~> 3.3'
  pod 'RxSwiftExt'
  pod 'Eureka', '4.3.0'
end

target 'Sieum' do
  # Pods for Sieum
  shared_pods
  pod 'FirebaseUI', '~> 7.0.0'
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKLoginKit'
  pod 'Toaster', :git => 'https://github.com/devxoul/Toaster.git', :branch => 'master'
  pod 'PanModal'
end

# Disable Code Coverage for Pods projects
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        end
    end
end
