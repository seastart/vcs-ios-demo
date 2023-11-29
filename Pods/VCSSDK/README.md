# 视频会议简介

[![CI Status](https://img.shields.io/travis/SailorGa/VCSSDK.svg?style=flat)](https://travis-ci.org/SailorGa/VCSSDK)
[![Version](https://img.shields.io/cocoapods/v/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)
[![License](https://img.shields.io/cocoapods/l/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)
[![Platform](https://img.shields.io/cocoapods/p/VCSSDK.svg?style=flat)](https://cocoapods.org/pods/VCSSDK)

客户端开发需要用到两部分：API和SDK。

API是以HTTP Restful形式提供的一组接口，主要负责帐号的登录、注册、充值、会议管理等操作，通过API接口获取到相应的入会凭证，然后才可以使用SDK库进入会议室，API详细接口请参见[《VCS服务端API文档》](https://www.yuque.com/anyconf/api)。

SDK是客户端的原生开发包，主要负责音视频流、互动以及会控服务（如踢人、禁言等）的相关操作。

对于部分会控功能，平台在API和SDK都有提供对应的实现方式。API方式主要提供给WEB端（管理后台）开发使用，建议客户端开发使用SDK方式。

![flow](Assets/flow.png)

# 开发文档

[开发文档地址](https://www.yuque.com/anyconf/ios)

# 集成方式

## Requirements

## Installation

VCSSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VCSSDK'
```

## Author

SailorGa, ljia789@gmail.com

## License

VCSSDK is available under the MIT license. See the LICENSE file for more info.
