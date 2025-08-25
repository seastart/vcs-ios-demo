# 指明依赖库的来源地址
source 'https://cdn.cocoapods.org'

# 说明平台和版本
platform :ios, '13.0'

# 忽略引入库的所有警告
inhibit_all_warnings!
use_frameworks!

def commonPods
  # 网络请求库
  pod 'AFNetworking'
  # 数据模型
  pod 'JSONModel'
  # 重置键盘
  pod 'IQKeyboardManager'
  # 动态响应链
  pod 'ReactiveObjC'
  # 本地资源选择器
  pod 'TZImagePickerController'
  # 图片加载
  pod 'SDWebImage'
  # 内测泄漏监测
  pod 'MLeaksFinder'
  # 数据模型
  pod 'YYModel'
end

def meetingPods
  # 本地依赖开发版VCSSDK
  pod 'VCSSDK', :path => '../../'
  # 本地依赖发布版VCSSDK
  # pod 'VCSSDK', :path => '../../Depend/VCSSDK'
  # 远程依赖VCSSDK分支
  # pod 'VCSSDK', :git => 'https://github.com/seastart/vcs-ios-cocoapods.git', :branch => 'cdnmeeting'
  # 远程依赖VCSSDK
  # pod 'VCSSDK'
end

def rtcreplayPods
  # SDK本地依赖
  pod 'RTCReplayKit', :path => "../../RTCReplayKit/Depend/RTCReplayKit/"
  # SDK远程依赖
  # pod 'RTCReplayKit'
end

target 'VCSSDK_Example' do
    commonPods
    meetingPods
end

target 'VCSReplayBroadcastUpload' do
  meetingPods
  # rtcreplayPods
end

pre_install do |installer|
  # 声明文件所在目录
  xcode12_temp_dir = "Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm"
  # 需要被替换的字符串
  xcode12_temp_findstr = "layoutCache[currentClass] = ivars;"
  # 需要替换成的字符串
  xcode12_temp_replacestr = "layoutCache[(id<NSCopying>)currentClass] = ivars;"
  # Fix for XCode 12.5
  find_and_replace(xcode12_temp_dir, xcode12_temp_findstr, xcode12_temp_replacestr);
  
  # 声明文件所在目录
  xcode13_temp_dir = "Pods/FBRetainCycleDetector/fishhook/fishhook.c"
  # 需要被替换的字符串
  xcode13_temp_findstr = "indirect_symbol_bindings[i] = cur->rebindings[j].replacement;"
  # 需要替换成的字符串
  xcode13_temp_replacestr = "if (i < (sizeof(indirect_symbol_bindings) / sizeof(indirect_symbol_bindings[0]))) { \n indirect_symbol_bindings[i]=cur->rebindings[j].replacement; \n }"
  # Fix for XCode 13.0
  find_and_replace(xcode13_temp_dir, xcode13_temp_findstr, xcode13_temp_replacestr);
  
  # 隐藏传递依赖错误
  def installer.verify_no_static_framework_transitive_dependencies; end
end

# 更改project配置
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['ARCHS'] = 'arm64'
            config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end

# 改动FBRetainCycleDetector适配代码
def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
      FileUtils.chmod("+w", name)
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
          puts "Fix: " + name
          File.open(name, "w") { |file| file.puts replace }
          STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
