@version = "3.0.0"
@podName = "ZHLocalizationStringManger"
@baseURL = "github.com"
@basePath = "josercc/#{@podName}"
@baseSourcePath = "#{@podName} Example/#{@podName}"
@baseFilePath = "**/*.{h,m}"
@source_files = "#{@baseSourcePath}/#{@baseFilePath}"
@frameworkName = "#{@podName}"
Pod::Spec.new do |s|
  s.name          = "#{@podName}"
  s.version       = @version
  s.summary       = ""
  s.homepage      = "https://#{@baseURL}/#{@basePath}"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "josercc" => "josercc@163.com" }
  s.platform      = :ios, '8.0'
  s.source        = { :git => "#{s.homepage}.git", :tag => "#{s.version}" }
  s.framework     = "UIKit"
  s.subspec 'Source' do |source|
    source.source_files = @source_files
  end
  s.subspec 'Framework' do |framework|
    framework.vendored_frameworks = "Carthage/build/iOS/#{@frameworkName}.framework"

  end
  s.prepare_command =  <<-CMD
  touch Cartfile
  echo 'git "git@#{@baseURL}:#{@basePath}.git" == #{@version}' > Cartfile
  Carthage update --platform iOS
  CMD
  s.default_subspecs = 'Source'

  # @subspec_config = [
  #   "Componment",
  #   "Defines"
  # ]
  # @subspec_config.each { |subspecName|
  #   s.subspec subspecName do |name|
  #     name.source_files = "#{@baseSourcePath}/#{subspecName}/#{@baseFilePath}"
  #   end
  # }

end
