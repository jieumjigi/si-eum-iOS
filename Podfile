# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
  use_frameworks!
  inhibit_all_warnings!
  pod 'SnapKit', '~> 4.0.0'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'DBImageColorPicker', '~> 1.0.0'
  pod 'Alamofire', '~> 4.3'
  pod 'SwiftyBeaver'
  pod 'PopupDialog', '~> 0.5'
  pod 'SwiftyJSON'
  pod 'Kingfisher', '~> 4.0'
  pod 'SHSideMenu', '~> 0.0.4' 
  pod 'RxDataSources', '~> 3.0'
  pod 'RxTheme', '2.0'
  pod 'Then'
  pod 'ObjectMapper', '~> 3.3'
  pod 'RxSwiftExt'
  pod 'Eureka', '4.3.0'
end

target 'sieum' do
  shared_pods
  # Pods for sieum
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKLoginKit'
end

target 'sieumTests' do
  inherit! :search_paths
  # Pods for testing
  shared_pods
  pod 'Quick'
  pod 'Nimble'
end

target 'sieumUITests' do
  inherit! :search_paths
  # Pods for testing
  shared_pods
end

target 'SieumWidget' do
  shared_pods
end
