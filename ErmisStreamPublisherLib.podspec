require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "ErmisStreamPublisherLib"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/giapdeviscool/ermis-stream-publisher-lib.git", :tag => "#{s.version}" }

  s.source_files = [
    "ios/**/*.{swift}",
    "ios/**/*.{m,mm}",
    "cpp/**/*.{hpp,cpp}",
  ]

  s.dependency 'React-jsi'
  s.dependency 'React-callinvoker'
  s.dependency 'HaishinKit', '~> 1.5.4'
  nitrogen_autolinking = File.join(__dir__, 'nitrogen/generated/ios/ErmisStreamPublisherLib+autolinking.rb')
  if File.exist?(nitrogen_autolinking)
    load nitrogen_autolinking
    add_nitrogen_files(s)
  end

  install_modules_dependencies(s)
end
