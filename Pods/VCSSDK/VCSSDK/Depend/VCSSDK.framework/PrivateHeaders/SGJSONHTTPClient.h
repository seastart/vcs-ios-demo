//
//  SGJSONModelHTTPClient.h
//  SGJSONModel
//

#import "SGJSONModel.h"

extern NSString *const kSGHTTPMethodGET DEPRECATED_ATTRIBUTE;
extern NSString *const kSGHTTPMethodPOST DEPRECATED_ATTRIBUTE;
extern NSString *const kSGContentTypeAutomatic DEPRECATED_ATTRIBUTE;
extern NSString *const kSGContentTypeSGJSON DEPRECATED_ATTRIBUTE;
extern NSString *const kSGContentTypeWWWEncoded DEPRECATED_ATTRIBUTE;

typedef void (^SGJSONObjectBlock)(id SGJSON, SGJSONModelError *err) DEPRECATED_ATTRIBUTE;

DEPRECATED_ATTRIBUTE
@interface SGJSONHTTPClient : NSObject

+ (NSMutableDictionary *)requestHeaders DEPRECATED_ATTRIBUTE;
+ (void)setDefaultTextEncoding:(NSStringEncoding)encoding DEPRECATED_ATTRIBUTE;
+ (void)setCachingPolicy:(NSURLRequestCachePolicy)policy DEPRECATED_ATTRIBUTE;
+ (void)setTimeoutInSeconds:(int)seconds DEPRECATED_ATTRIBUTE;
+ (void)setRequestContentType:(NSString *)contentTypeString DEPRECATED_ATTRIBUTE;
+ (void)getSGJSONFromURLWithString:(NSString *)urlString completion:(SGJSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)getSGJSONFromURLWithString:(NSString *)urlString params:(NSDictionary *)params completion:(SGJSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)SGJSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyString:(NSString *)bodyString completion:(SGJSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)SGJSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyString:(NSString *)bodyString headers:(NSDictionary *)headers completion:(SGJSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)SGJSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyData:(NSData *)bodyData headers:(NSDictionary *)headers completion:(SGJSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)postSGJSONFromURLWithString:(NSString *)urlString params:(NSDictionary *)params completion:(SGJSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)postSGJSONFromURLWithString:(NSString *)urlString bodyString:(NSString *)bodyString completion:(SGJSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)postSGJSONFromURLWithString:(NSString *)urlString bodyData:(NSData *)bodyData completion:(SGJSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;

@end
