## 视频会议简介

[![CI Status](https://img.shields.io/travis/SailorGa/VCSSDK.svg?style=flat)](https://travis-ci.org/SailorGa/VCSSDK)
[![Version](https://img.shields.io/cocoapods/v/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)
[![License](https://img.shields.io/cocoapods/l/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)
[![Platform](https://img.shields.io/cocoapods/p/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)

客户端开发需要用到两部分：API和SDK。

API是以HTTP Restful形式提供的一组接口，主要负责帐号的登录、注册、充值、会议管理等操作，通过API接口获取到相应的入会凭证，然后才可以使用SDK库进入会议室，API详细接口请参见[《VCS服务端API开发手册》](https://www.yuque.com/anyconf/api?# 《VCS SDK 服务端API 开发手册》)。

## 示例的使用

step 1：下载示例到本地

```
git clone git@github.com:seastart/vcs-ios-demo.git 或 直接下载压缩包
```

step 2：变更```Podfile```文件中的依赖为远程依赖

```
pod 'VCSSDK'
```

step 3：重新安装示例所需的依赖

```
pod install
```

step 4：替换申请的```AppID```和```AppKey```

```
NSString * const VCSSDKAPPID = <# 替换成平台分配的Appid #>
NSString * const VCSSDKAPPKEY = <# 替换成平台分配的AppKey #>
```

## Author

SailorGa, ljia789@gmail.com

## License

VCSSDK is available under the MIT license. See the LICENSE file for more info.
