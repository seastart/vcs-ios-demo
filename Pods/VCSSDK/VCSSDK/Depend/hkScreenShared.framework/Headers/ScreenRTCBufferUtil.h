//
//  ScreenRTCBufferUtil.h
//  hkScreenShared
//
//  Created by rich rich on 28/5/2020.
//  Copyright © 2020 rich rich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ScreenRTCBufferUtil : NSObject
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth;
+ (size_t)getCMTimeSize;
+(CVPixelBufferRef)CVPixelBufferRefFromUiImage:(UIImage *)img;
+ (CMSampleBufferRef)sampleBufferFromPixbuffer:(CVPixelBufferRef)pixbuffer timeData:(NSData *)data;
+ (CMSampleBufferRef)sampleBufferFromPixbuffer:(CVPixelBufferRef)pixbuffer time:(CMTime)time;
+ (UIImage *)imageFromBuffer:(CMSampleBufferRef)buffer;
@end

NS_ASSUME_NONNULL_END
