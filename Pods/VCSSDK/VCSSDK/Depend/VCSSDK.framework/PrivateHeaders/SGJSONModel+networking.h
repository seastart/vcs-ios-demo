//
//  SGJSONModel+networking.h
//  SGJSONModel
//

#import "SGJSONModel.h"
#import "SGJSONHTTPClient.h"

typedef void (^SGJSONModelBlock)(id model, SGJSONModelError *err) DEPRECATED_ATTRIBUTE;

@interface SGJSONModel (Networking)

@property (assign, nonatomic) BOOL isSGLoading DEPRECATED_ATTRIBUTE;
- (instancetype)initFromURLWithString:(NSString *)urlString completion:(SGJSONModelBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)getModelFromURLWithString:(NSString *)urlString completion:(SGJSONModelBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)postModel:(SGJSONModel *)post toURLWithString:(NSString *)urlString completion:(SGJSONModelBlock)completeBlock DEPRECATED_ATTRIBUTE;

@end
