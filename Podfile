# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'OlympusCVM' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

  # Pods for OlympusCVM
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod "youtube-ios-player-helper", "~> 0.1.4"

  target 'OlympusCVMTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OlympusCVMUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
