# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FOREYOU' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

 pod 'AWSS3'
  pod 'AWSCognito'
  pod 'AWSCore'
  pod 'Alamofire'
  pod 'Alamofire-SwiftyJSON'
  pod 'MapleBacon', '5.2.1'
  pod 'IQKeyboardManagerSwift'
  pod 'ReachabilitySwift'
  pod 'CountryPickerView'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKPlacesKit'
  pod 'GoogleSignIn'
  pod 'CropViewController'
  pod "BSImagePicker", "~> 3.0"
  pod 'SnapSDK', :subspecs => ['SCSDKLoginKit', 'SCSDKCreativeKit', 'SCSDKBitmojiKit']
  pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'
  pod 'Firebase/Auth'
  pod 'FirebaseUI/OAuth'
  pod 'SDWebImage', '~> 4.0'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod "KWVerificationCodeView"
 pod  'FirebaseDatabase', "~> 7.3.0"
  pod 'Firebase/Firestore'
  pod 'Kingfisher', '~> 7.0'

  pod 'Lightbox'
  pod 'TTTAttributedLabel'
  pod 'SVProgressHUD'

# Pods for FOREYOU
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # Needed for building for simulator on M1 Macs
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end

end
