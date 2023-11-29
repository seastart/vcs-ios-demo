//
//  SGJSONModelError.h
//  SGJSONModel
//

#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////////////////////////////
typedef NS_ENUM(int, kSGJSONModelErrorTypes)
{
    kSGJSONModelErrorInvalidData = 1,
    kSGJSONModelErrorBadResponse = 2,
    kSGJSONModelErrorBadSGJSON = 3,
    kSGJSONModelErrorModelIsInvalid = 4,
    kSGJSONModelErrorNilInput = 5
};

/////////////////////////////////////////////////////////////////////////////////////////////
/** The domain name used for the SGJSONModelError instances */
extern NSString *const SGJSONModelErrorDomain;

/**
 * If the model SGJSON input misses keys that are required, check the
 * userInfo dictionary of the SGJSONModelError instance you get back -
 * under the kSGJSONModelMissingKeys key you will find a list of the
 * names of the missing keys.
 */
extern NSString *const kSGJSONModelMissingKeys;

/**
 * If SGJSON input has a different type than expected by the model, check the
 * userInfo dictionary of the SGJSONModelError instance you get back -
 * under the kSGJSONModelTypeMismatch key you will find a description
 * of the mismatched types.
 */
extern NSString *const kSGJSONModelTypeMismatch;

/**
 * If an error occurs in a nested model, check the userInfo dictionary of
 * the SGJSONModelError instance you get back - under the kSGJSONModelKeyPath
 * key you will find key-path at which the error occurred.
 */
extern NSString *const kSGJSONModelKeyPath;

/////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Custom NSError subclass with shortcut methods for creating
 * the common SGJSONModel errors
 */
@interface SGJSONModelError : NSError

@property (strong, nonatomic) NSHTTPURLResponse *httpResponse;

@property (strong, nonatomic) NSData *responseData;

/**
 * Creates a SGJSONModelError instance with code kSGJSONModelErrorInvalidData = 1
 */
+ (id)errorInvalidDataWithMessage:(NSString *)message;

/**
 * Creates a SGJSONModelError instance with code kSGJSONModelErrorInvalidData = 1
 * @param keys a set of field names that were required, but not found in the input
 */
+ (id)errorInvalidDataWithMissingKeys:(NSSet *)keys;

/**
 * Creates a SGJSONModelError instance with code kSGJSONModelErrorInvalidData = 1
 * @param mismatchDescription description of the type mismatch that was encountered.
 */
+ (id)errorInvalidDataWithTypeMismatch:(NSString *)mismatchDescription;

/**
 * Creates a SGJSONModelError instance with code kSGJSONModelErrorBadResponse = 2
 */
+ (id)errorBadResponse;

/**
 * Creates a SGJSONModelError instance with code kSGJSONModelErrorBadSGJSON = 3
 */
+ (id)errorBadSGJSON;

/**
 * Creates a SGJSONModelError instance with code kSGJSONModelErrorModelIsInvalid = 4
 */
+ (id)errorModelIsInvalid;

/**
 * Creates a SGJSONModelError instance with code kSGJSONModelErrorNilInput = 5
 */
+ (id)errorInputIsNil;

/**
 * Creates a new SGJSONModelError with the same values plus information about the key-path of the error.
 * Properties in the new error object are the same as those from the receiver,
 * except that a new key kSGJSONModelKeyPath is added to the userInfo dictionary.
 * This key contains the component string parameter. If the key is already present
 * then the new error object has the component string prepended to the existing value.
 */
- (instancetype)errorByPrependingKeyPathComponent:(NSString *)component;

/////////////////////////////////////////////////////////////////////////////////////////////
@end
